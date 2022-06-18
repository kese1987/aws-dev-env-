
variable "instance-config" {
  type = map(any)
}

variable "vpc-id" {
  type = string
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

variable "public-dns-zone" {
  type = object({
    name = string
    id   = string
  })
}

