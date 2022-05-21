resource "aws_route53_record" "vpn-gw" {
  zone_id = var.dns-zone.id
  name    = format("%s.%s", "vpn", var.dns-zone.name)
  type    = "A"
  ttl     = "300"
  records = [aws_eip.vpn.public_ip]
}