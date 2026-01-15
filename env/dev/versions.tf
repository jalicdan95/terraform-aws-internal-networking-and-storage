terraform {
  required_version = ">= 1.6.0"

  cloud {
    organization = "NadcilaSolutions"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.28.0"
    }
  }
}
