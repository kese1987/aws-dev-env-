resource "aws_instance" "openvpn" {
  ami           = "ami-0d527b8c289b4af7f"
  instance_type = "t2.medium"

  availability_zone = var.instance-config.openvpn.az
  subnet_id         = var.instance-config.openvpn.subnet
  key_name          = var.known-key-pairs[var.instance-config.openvpn.key-name].key-name
  security_groups =  [aws_security_group.openvpn-sg.id]

  tags = {
    Name = "EnterpriseServicesInstance"
  }

  #local provisioner get executed without checking the availability of the actual resource to configure
  #to overcome this limitation, and knowing that remote-exec is executed before the local-exec, and it wait
  #for the resource to be available, we setup a dummy remote execution.


  depends_on = [aws_security_group.openvpn-sg]
}