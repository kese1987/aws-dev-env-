############## PUBLIC RECORDS
resource "aws_route53_record" "vpn-gw" {
  zone_id = var.public-dns-zone.id
  name    = format("%s.%s", "vpn", var.public-dns-zone.name)
  type    = "A"
  ttl     = "300"
  records = [data.aws_eip.openvpn.public_ip]
}

############# PRIVATE RECORDS
resource "aws_route53_record" "private-openvpn" {
  zone_id = var.private-dns-zone.id
  name    = format("%s.%s", "openvpn", var.private-dns-zone.name)
  type    = "A"
  ttl     = "300"
  records = [aws_instance.openvpn.private_ip]
}