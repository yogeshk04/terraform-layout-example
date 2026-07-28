########################################
# Remote state backend
#
# Create the bucket and lock table with `bootstrap/` FIRST, then update
# the values below to match its outputs and run `terraform init`.
########################################

terraform {
  backend "s3" {
    bucket         = "myapp-terraform-state-CHANGE-ME"
    key            = "myapp/dev/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "myapp-terraform-locks"
    encrypt        = true
  }
}
