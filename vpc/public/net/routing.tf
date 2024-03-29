resource "aws_route_table" "public" {
  vpc_id = var.vpc-id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }


  tags = {
    Name = "public"
  }
}

resource "aws_route_table_association" "public-subnet-rt" {
  subnet_id      = aws_subnet.public-subnets[var.primary-public-subnet].id
  route_table_id = aws_route_table.public.id
}