variable "aws-region" {
  type = string
}

variable "dns-zone" {
  type = object({
    id   = string
    name = string
  })
}

variable "private-dns-zone" {
  type = object({
    name = string
  })
}

variable "vpc_dns" {
  type = string
}
variable "vpc_cidr_block" {
  type = string
}

variable "vpc-subnets" {
  type = object({
    private = map(any)
    public  = map(any)
  })
}

variable "primary-public-subnet" {
  type = string
}

variable "az" {
  type = string
}

variable "known-key-pairs" {
  type = map(any)
}

variable "instance-config" {
  type = any
}