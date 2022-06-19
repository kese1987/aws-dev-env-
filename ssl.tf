
resource "tls_private_key" "private_key" {
  algorithm = "RSA"

  lifecycle {
    prevent_destroy = true
  }
}

resource "acme_registration" "registration" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = "kese87@gmail.com"

  lifecycle {
    prevent_destroy = true
  }
}

resource "acme_certificate" "certificate" {
  account_key_pem           = acme_registration.registration.account_key_pem
  common_name               = "*.${data.aws_route53_zone.francierika-click.name}"

  dns_challenge {
    provider = "route53"

    config = {
      AWS_HOSTED_ZONE_ID = data.aws_route53_zone.francierika-click.zone_id
      AWS_PROFILE = var.aws-profile
      AWS_REGION = var.aws-region
    }
  }

  lifecycle {
    prevent_destroy = true
  }

  depends_on = [acme_registration.registration]
}

resource "local_file" "cert_files" {
  for_each = toset(["certificate_pem", "issuer_pem", "private_key_pem"])

  filename = "${abspath(path.module)}/ssl_certs/${each.key}"
  content = lookup(acme_certificate.certificate, "${each.key}")

  lifecycle {
       prevent_destroy = true
  }
}