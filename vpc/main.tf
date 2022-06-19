resource "aws_vpc" "enricos-vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = "enricos-vpc"
  }
}

##############################################
############### PUBLIC #######################

module "public-net" {
  source                = "./public/net"
  dns-zone              = var.dns-zone
  vpc-id                = aws_vpc.enricos-vpc.id
  az                    = var.az
  subnets               = var.vpc-subnets.public
  primary-public-subnet = var.primary-public-subnet
}

##############################################
############### PRIVATE #######################

module "private-net" {
  source           = "./private/net"
  vpc-id           = aws_vpc.enricos-vpc.id
  public-nat-gw-id = module.public-net.nat-gw-id
  az               = var.az
  dns-zone         = var.private-dns-zone
  subnets          = var.vpc-subnets.private
}

module "internal_tools" {
  source          = "./private/instances/internal_tools"
  known-key-pairs = var.known-key-pairs
  private-dns-zone = {
    name = aws_route53_zone.private-zone.name
    id   = aws_route53_zone.private-zone.id
  }
  vpc-id          = aws_vpc.enricos-vpc.id
  private_subnets = concat(tolist([for k, v in var.vpc-subnets.private : v.cidr-block]), tolist([for k, v in var.vpc-subnets.public : v.cidr-block]))
  instance-config = {
    internal_tools = merge(
      tomap({
        az = var.az
      }),
    var.instance-config.internal_tools)
  }

  depends_on = [aws_route53_zone.private-zone]
}

############## PUBLIC INSTANCES #########################
module "public-instances" {
  source          = "./public/instances/openvpn"
  vpc-id          = aws_vpc.enricos-vpc.id
  known-key-pairs = var.known-key-pairs
  private-dns-zone = {
    name = aws_route53_zone.private-zone.name
    id   = aws_route53_zone.private-zone.id
  }
  public-dns-zone = var.dns-zone

  instance-config = {
    openvpn = merge(
      tomap({
        az         = var.az
        subnet     = module.public-net.subnets[0]
        eip        = module.public-net.eips.vpn
        routes     = jsonencode([for route_cidr in var.instance-config.openvpn.push-routes : format("%s %s", regex("\\d+\\.\\d+\\.\\d+\\.\\d+", route_cidr), cidrnetmask(route_cidr))])
        dns-server = var.vpc_dns
      }),
    var.instance-config.openvpn)
  }
  depends_on = [aws_route53_zone.private-zone]
}