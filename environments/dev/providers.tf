terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.57.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">=1.13.2"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.9.0"
    }
  }
}

provider "aws" {
  #shared_config_files      = ["$HOME/.aws/config"]

  region                   = "eu-central-1"
  shared_credentials_files = ["$HOME/.aws/credentials"]
  profile                  = "dev"
}
