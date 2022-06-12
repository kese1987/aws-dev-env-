output "subnets" {
  value = [for k,v in var.subnets :  aws_subnet.public-subnets[k].id]
}

output "nat-gw-id" {
  value = aws_nat_gateway.public.id
}

output "eips" {
    value = {
        vpn=aws_eip.vpn.id
    }
}