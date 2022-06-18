data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_route53_zone" "francierika-click" {
  name = "francierika.click"
}