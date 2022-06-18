resource "aws_instance" "internal_tools" {
  ami           = "ami-0d527b8c289b4af7f"
  instance_type = "t2.medium"

  availability_zone = var.instance-config.internal_tools.az
  subnet_id         = var.instance-config.internal_tools.subnet
  key_name          = var.known-key-pairs[var.instance-config.internal_tools.key-name].key-name
  vpc_security_group_ids = [aws_security_group.internaltools-sg.id]

  tags = {
    Name = "internal_tools"
  }

  #local provisioner get executed without checking the availability of the actual resource to configure
  #to overcome this limitation, and knowing that remote-exec is executed before the local-exec, and it wait
  #for the resource to be available, we setup a dummy remote execution.

}

resource "aws_security_group" "internaltools-sg" {
  name   = "internaltools-sg"
  vpc_id = var.vpc-id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = var.private_subnets
  }

  ingress {
    from_port        = 9090
    to_port          = 9090
    protocol         = "tcp"
    cidr_blocks      = var.private_subnets
  }

  ingress {
    from_port        = 8
    to_port          = -1
    protocol         = "icmp"
    cidr_blocks      = var.private_subnets
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "internal_tools_sg"
  }
}