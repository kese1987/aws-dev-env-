resource "aws_route53_record" "private-internal-tools" {
  zone_id = var.private-dns-zone.id
  name    = "internaltools.${var.private-dns-zone.name}"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.internal_tools.private_ip]
}