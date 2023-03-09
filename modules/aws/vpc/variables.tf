variable "infra_env" {
  type        = string
  description = "Infrastructure environment"
}

variable "vpc_cidr" {
  type        = string
  description = "The IP range to use for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_numbers" {
  type        = map(number)
  description = "Map of AZ to number that should be used for public subnets"

  default = {
    "eu-central-1" = 1
    "eu-west-1"    = 1
  }
}

variable "private_subnet_numbers" {
  type        = map(number)
  description = "Map of AZ to number that should be used for private subnets"

  default = {
    "eu-central-1" = 1
    "eu-west-1"    = 1
  }

}
