#provision public ip to reach nat gw
resource "aws_eip" "nat" {

  tags = {
    Name = "nat"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip" "vpn" {
  tags = {
    Name = "vpn"
  }

  depends_on = [aws_internet_gateway.igw]
}