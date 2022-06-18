variable "dns-zone" {
  type = object({
    id   = string
    name = string
  })
}

variable "subnets" {
  type = map(any)
}

variable "vpc-id" {
  type = string
}

variable "az" {
  type = string
}

variable "primary-public-subnet" {
  type = string
}