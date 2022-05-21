output "subnets" {
  value = [aws_subnet.public-subnet.id]
}

output "nat-gw-id" {
  value = aws_nat_gateway.public.id
}

output "eips" {
    value = {
        vpn=aws_eip.vpn.id
    }
}