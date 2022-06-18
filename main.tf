terraform {
  backend "local" {
    path = "state.tfstate"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}


module "vpc" {
  source     = "./vpc"
  aws-region = var.aws-region
  dns-zone = {
    id   = data.aws_route53_zone.francierika-click.id
    name = data.aws_route53_zone.francierika-click.name
  }
  private-dns-zone = {
    name = "francierika.lan"
  }
  vpc_cidr_block = "10.0.0.0/16"
  vpc_dns        = "10.0.0.2"
  vpc-subnets = {
    private = {
      private-subnet = {
        cidr-block = "10.0.64.0/18"
      }
      vpn-clients = {
        cidr-block = "10.0.128.0/24"
      }
    }
    public = {
      public-subnet = {
        cidr-block = "10.0.0.0/18"
      }
    }
  }
  primary-public-subnet = "public-subnet"
  known-key-pairs       = local.known-key-pairs
  instance-config = {
    openvpn = {
      vpn-network-cidr   = "10.0.128.0/24"
      push-routes        = ["10.0.64.0/18", "10.0.128.0/24", "10.0.0.0/18"]
      key-name           = "enrico-mbp"
      ca-crt             = "/usr/local/etc/pki/ca.crt"
      server-crt         = "/usr/local/etc/pki/issued/openvpn-server.crt"
      server-private-key = "/usr/local/etc/pki/private/openvpn-server.key"
      server-static-key  = "/usr/local/etc/pki/ta.key"
    }
    internal_tools = {
      key-name           = "enrico-mbp"
    }
  }

  az = data.aws_availability_zones.available.names[0]
}
