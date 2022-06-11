resource "aws_instance" "openvpn" {
  ami           = "ami-0d527b8c289b4af7f"
  instance_type = "t2.micro"

  availability_zone = var.instance-config.openvpn.az
  subnet_id         = var.instance-config.openvpn.subnet
  key_name          = var.known-key-pairs[var.instance-config.openvpn.key-name].key-name
  security_groups =  [aws_security_group.openvpn-sg.id]
  source_dest_check = false

tags = {
    Name = "OpenVpn"
  }

  #local provisioner get executed without checking the availability of the actual resource to configure
  #to overcome this limitation, and knowing that remote-exec is executed before the local-exec, and it wait
  #for the resource to be available, we setup a dummy remote execution.
  

  depends_on = [aws_security_group.openvpn-sg]
}

resource "local_file" "openvpn_ansible_vars" {
  content = <<-DOC
    tf_vpn_subnet: ${cidrnetmask(var.instance-config.openvpn.vpn-network-cidr)}
    tf_vpn_network: ${regex("\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}",var.instance-config.openvpn.vpn-network-cidr)}
    tf_vpn_cidr: ${var.instance-config.openvpn.vpn-network-cidr}
    tf_cwd: ${abspath(path.module)}/ansible
    tf_ca_crt: ${var.instance-config.openvpn.ca-crt}
    tf_server_crt: ${var.instance-config.openvpn.server-crt}
    tf_server_key: ${var.instance-config.openvpn.server-private-key}
    tf_server_static_key: ${var.instance-config.openvpn.server-static-key}
    tf_push_routes: ${var.instance-config.openvpn.push-routes}
    tf_dns_server: ${var.instance-config.openvpn.dns-server}
    tf_private_dns_zone: ${var.private-dns-zone.name}
  DOC
  filename = "${abspath(path.module)}/ansible/tf_openvpn_vars.yml"
}

resource "null_resource" "openvpn-config"{

  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "remote-exec" {
    inline = ["echo \"instance ready!\""]

    connection {
      host        = data.aws_eip.openvpn.public_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.known-key-pairs[var.instance-config.openvpn.key-name].private-key-file)
    }
  }
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu -i '${data.aws_eip.openvpn.public_ip},' --extra-var=@${abspath(path.module)}/ansible/tf_openvpn_vars.yml --private-key ${var.known-key-pairs.enrico-mbp.private-key-file} ${abspath(path.module)}/ansible/main.yml"
  }

  depends_on = [
    aws_eip_association.openvpn-assoc,
    aws_instance.openvpn
  ]

}

resource "aws_eip_association" "openvpn-assoc" {
  instance_id   = aws_instance.openvpn.id
  allocation_id = var.instance-config.openvpn.eip
}

resource "aws_security_group" "openvpn-sg" {
  name        = "openvpn-sg"
  vpc_id      = var.vpc-id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 1194
    to_port          = 1194
    protocol         = "udp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}