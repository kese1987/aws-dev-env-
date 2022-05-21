variable "aws-region" {
  type = string
}

variable "dns-zone" {
  type = object({
    id   = string
    name = string
  })
}

variable "az" {
  type = string
}

variable "known-key-pairs" {
  type = map(any)
}

variable "instance-config" {
    type = map(any)
}