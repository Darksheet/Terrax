terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4"
    }
    tls = { 
      source  = "hashicorp/tls"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2"
    }
  }
}

# PDMZ provider
provider "aws" {
  region = var.region
}

provider "local" {
  alias= "pem"
}
provider "tls" {
  alias= "key"
}