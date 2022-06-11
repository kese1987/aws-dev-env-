resource "aws_route53_zone" "private-zone" {
  name = var.private-dns-zone.name

  vpc {
    vpc_id = aws_vpc.enricos-vpc.id
  }
}


#resource "aws_route53_record" "private-zone-delegation" {
#  zone_id = var.dns-zone.id
#  name    = var.private-dns-zone.name
#  type    = "NS"
#  ttl     = "300"
#  records = aws_route53_zone.private-zone.name_servers
#}