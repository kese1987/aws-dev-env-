variable "dns-zone" {
    type=object({
        id=string
        name=string
    })
}

variable "vpc-id" {
  type=string
}

variable "az" {
  type=string
}