terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.57.1"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
  #shared_config_files      = ["$HOME/.aws/config"]
  shared_credentials_files = ["$HOME/.aws/credentials"]
  profile                  = "admin"
}

terraform {
  backend "s3" {
    profile = "admin"
    bucket = "terraform-tfstate"
    region = "us-west-2"
    dynamodb_table = "terraform-tflock"
    encrypt = true
    key = "preprod/terraform.tfstate"
  }
}

module "lock-setup" {
  source = "./lockSetup"
}

# Add your providers below

module "prod-us-west-2" {
  source = "../../providers/aws/prod"
  region = "us-west-2"
  profile = "${var.profile}"
}

module "prod-us-east-2" {
  source = "../../providers/aws/prod"
  region = "us-east-2"
  profile = "${var.profile}"
}
