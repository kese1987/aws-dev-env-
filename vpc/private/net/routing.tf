resource "aws_route_table" "private" {
  vpc_id = var.vpc-id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.public-nat-gw-id
  }


  tags = {
    Name = "private-rt"
  }
}

resource "aws_route_table_association" "private-subnet-rt" {
  for_each = aws_subnet.private-subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}