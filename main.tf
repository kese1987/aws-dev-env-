terraform {
  backend "local" {
    path = "state.tfstate"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}


module "vpc" {
  source     = "./vpc"
  aws-region = var.aws-region
  dns-zone = {
    id   = data.aws_route53_zone.francierika-click.id
    name = data.aws_route53_zone.francierika-click.name
  }
  known-key-pairs = local.known-key-pairs
  instance-config = {
    openvpn={
      key-name = "enrico-mbp"
      ca-crt = "/usr/local/etc/pki/ca.crt"
      server-crt = "/usr/local/etc/pki/issued/openvpn-server.crt"
      server-private-key = "/usr/local/etc/pki/private/openvpn-server.key"
      server-static-key = "/usr/local/etc/pki/ta.key"
    }
  }
  
  az = data.aws_availability_zones.available.names[0]
}
