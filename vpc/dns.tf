resource "aws_route53_zone" "private-zone" {
  name = var.private-dns-zone.name

  vpc {
    vpc_id = aws_vpc.enricos-vpc.id
  }
}