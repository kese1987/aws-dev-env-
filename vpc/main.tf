resource "aws_vpc" "enricos-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "enricos-vpc"
  }
}

##############################################
############### PUBLIC #######################

module "public-net" {
  source   = "./public/net"
  dns-zone = var.dns-zone
  vpc-id   = aws_vpc.enricos-vpc.id
  az       = var.az
}

module "public-instances-openvpn" {
  source     = "./public/instances/openvpn"
  vpc-id   = aws_vpc.enricos-vpc.id
  known-key-pairs = var.known-key-pairs
  instance-config = {
    openvpn = merge(
      tomap({
        az = var.az
        subnet = module.public-net.subnets[0]
        eip = module.public-net.eips.vpn
        vpn-network-cidr = "10.0.128.0/24"
        push-routes = jsonencode(["10.0.0.0 255.255.192.0", "10.0.64.0 255.255.192.0"])
        dns-server = "10.0.0.2 255.255.192.0"
      }), 
      var.instance-config.openvpn)
  }
}

##############################################
############### PRIVATE #######################

module "private-net" {
  source           = "./private/net"
  vpc-id           = aws_vpc.enricos-vpc.id
  public-nat-gw-id = module.public-net.nat-gw-id
  az               = var.az
  subnets          = {
    private-subnet = {
      cidr-block = "10.0.64.0/18"
    }
    vpn-clients = {
      cidr-block = "10.0.128.0/24"
    }        
  }
}