variable "aws-region" {
  description = "aws region on which terraform is applied"
  default     = "eu-central-1"
}

variable "aws-profile" {
  default     = "terraform"
}

locals {
  known-key-pairs = {
    enrico-mbp = {
      key-name         = "enrico-mbp"
      private-key-file = "/Users/enrico/.ssh/id_rsa"
      public-key       = file("/Users/enrico/.ssh/id_rsa.pub")
    }
  }
}