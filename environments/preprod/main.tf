variable "profile" { default = "preprod" }
variable "region" { default = "us-west-2" }

provider "aws" {
  region  = var.region
  profile = var.profile
}

terraform {
  backend "s3" {
    profile        = "admin"
    bucket         = "terraform-tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-tflock"
    encrypt        = true
    key            = "preprod/terraform.tfstate"
  }
}

module "eks" {
  source             = "../../modules/aws/eks"
  cluster_name       = var.cluster_name
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.vpc_private_subnets.id
  node_group_name    = var.node_group_name
  node_instance_type = var.node_instance_type
  desired_capacity   = var.desired_capacity
  min_size           = var.min_size
  max_size           = var.max_size

  depends_on = [
    module.vpc
  ]
}
