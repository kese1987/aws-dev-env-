resource "aws_nat_gateway" "public" {
  allocation_id     = aws_eip.nat.id
  subnet_id         = aws_subnet.public-subnet.id
  connectivity_type = "public"

  tags = {
    Name = "public Nat gw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}