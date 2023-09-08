# environment variabls
variable "region" {}
variable "project_name" {}
variable "environment" {}

# VPC variables
# VPC cidr block
variable "vpc_cidr" {}

# Public subnet cider
variable "public_subnet_az1_cidr" {}
variable "public_subnet_az2_cidr" {}

# Private app subnet cidr
variable "private_app_subnet_az1_cidr" {}
variable "private_app_subnet_az2_cidr" {}

# Private data subnet cidr
variable "private_data_subnet_az1_cidr" {}
variable "private_data_subnet_az2_cidr" {}
