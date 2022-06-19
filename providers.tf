provider "aws" {
  region  = var.aws-region
  profile = var.aws-profile
}

provider "acme" {
  server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
  #server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

