terraform {
  backend "s3" {
    bucket         = "myapp-terraform-state-CHANGE-ME"
    key            = "myapp/staging/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "myapp-terraform-locks"
    encrypt        = true
  }
}
