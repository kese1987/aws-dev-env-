resource "aws_instance" "internal_tools" {
  ami           = "ami-0d527b8c289b4af7f"
  instance_type = "t2.medium"

  availability_zone      = var.instance-config.internal_tools.az
  subnet_id              = data.aws_subnet.services_private_subnet.id
  key_name               = var.known-key-pairs[var.instance-config.internal_tools.key-name].key-name
  vpc_security_group_ids = [aws_security_group.internaltools-sg.id]

  tags = {
    Name = "internal_tools"
  }

  #local provisioner get executed without checking the availability of the actual resource to configure
  #to overcome this limitation, and knowing that remote-exec is executed before the local-exec, and it wait
  #for the resource to be available, we setup a dummy remote execution.



}

resource "null_resource" "internaltools-config" {

  triggers = {
    policy_sha1 = sha1(join("", tolist([for f in fileset("${path.module}/ansible/", "*") : file("${path.module}/ansible/${f}")])))
  }

  provisioner "remote-exec" {
    inline = ["echo \"instance ready!\""]

    connection {
      host        = "internaltools.${var.private-dns-zone.name}"
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.known-key-pairs[var.instance-config.internal_tools.key-name].private-key-file)
    }
  }
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu -i 'internaltools.${var.private-dns-zone.name},' --private-key ${var.known-key-pairs.enrico-mbp.private-key-file} ${abspath(path.module)}/ansible/main.yml"
  }

  depends_on = [
    aws_route53_record.private-internal-tools,
    aws_instance.internal_tools
  ]

}

resource "aws_security_group" "internaltools-sg" {
  name   = "internaltools-sg"
  vpc_id = var.vpc-id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.private_subnets
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = var.private_subnets
  }

  ingress {
    from_port   = 8
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = var.private_subnets
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