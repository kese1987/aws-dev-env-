#public subnet, will host public services
resource "aws_subnet" "public-subnet" {
  vpc_id            = var.vpc-id
  cidr_block        = "10.0.0.0/18"
  availability_zone = var.az
  tags = {
    Name = "public-subnet"
  }
}






