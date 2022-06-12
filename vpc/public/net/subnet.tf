#public subnet, will host public services
resource "aws_subnet" "public-subnets" {
  for_each = var.subnets

  vpc_id            = var.vpc-id
  cidr_block        = each.value.cidr-block
  availability_zone = var.az

  tags = {
    Name = each.key
  }
}


