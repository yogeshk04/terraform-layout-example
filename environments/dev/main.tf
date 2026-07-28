########################################
# dev environment
#
# Root module: composes reusable modules from ../../modules/.
# Add or remove module blocks below as this environment grows.
########################################

locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

########################################
# Network
########################################

module "vpc" {
  source = "../../modules/vpc"

  project_name         = var.project_name
  environment          = var.environment
  cidr_block           = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  single_nat_gateway   = true

  tags = local.common_tags
}

########################################
# Example: uncomment and configure to add more resources.
########################################

# module "web" {
#   source = "../../modules/ec2"
#
#   project_name           = var.project_name
#   environment            = var.environment
#   name                   = "web"
#   ami_id                 = "ami-XXXXXXXXXXXXXXXXX"
#   instance_type          = "t3.micro"
#   subnet_id              = module.vpc.public_subnet_ids[0]
#   vpc_security_group_ids = []  # supply a SG created elsewhere
#   allocate_eip           = true
#
#   tags = local.common_tags
# }

# module "app_bucket" {
#   source = "../../modules/s3"
#
#   bucket_name = "${var.project_name}-${var.environment}-app"
#   tags        = local.common_tags
# }
