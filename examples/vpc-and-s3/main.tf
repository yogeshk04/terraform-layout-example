########################################
# Example: standalone VPC + S3 bucket
#
# Uses local state (no backend). Handy for quick tests; not for real
# environments \u2014 use environments/dev|staging|prod for those.
########################################

module "vpc" {
  source = "../../modules/vpc"

  project_name         = var.project_name
  environment          = "example"
  cidr_block           = "10.99.0.0/16"
  availability_zones   = ["${var.region}a", "${var.region}b"]
  public_subnet_cidrs  = ["10.99.0.0/24", "10.99.1.0/24"]
  private_subnet_cidrs = ["10.99.10.0/24", "10.99.11.0/24"]
  single_nat_gateway   = true
}

module "bucket" {
  source = "../../modules/s3"

  bucket_name = var.bucket_name
}
