
variable "instance-config" {
  type = map(any)
}

variable "vpc-id" {
  type = string
}

variable "known-key-pairs" {
  type = map(any)
}

