variable "vpc-id" {
  type = string
}

variable "public-nat-gw-id" {
  type = string
}

variable "az" {
  type = string
}

variable "subnets" {
  type = map(any)
}

variable "dns-zone" {
  type = object({
    name = string
  })
}