data "aws_eip" "openvpn" {
    id=var.instance-config.openvpn.eip
}