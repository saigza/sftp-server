terraform {
  required_version = ">= 1.0"

  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = ">= 3.8.2"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.9"
    }
    archive = ">= 2.2"
  }
}
