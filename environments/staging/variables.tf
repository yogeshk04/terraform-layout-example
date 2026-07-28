variable "project_name" {
  description = "Short project identifier used for naming and tagging."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "staging"
}

variable "region" {
  description = "AWS region."
  type        = string
}

variable "profile" {
  description = "AWS CLI profile."
  type        = string
  default     = "default"
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block for the VPC."
  type        = string
}

variable "availability_zones" {
  description = "List of AZs to spread subnets across."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets. One per AZ."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets. One per AZ."
  type        = list(string)
}
