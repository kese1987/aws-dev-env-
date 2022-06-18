variable "instance-config" {
  type = any
}

variable "known-key-pairs" {
  type = map(any)
}

variable "private-dns-zone" {
  type = object({
    name = string
    id   = string
  })
}

variable "vpc-id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}