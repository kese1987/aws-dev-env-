#internet gw to enable internet access the public subnet
resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc-id

  tags = {
    Name = "public-subnet-igw"
  }
}