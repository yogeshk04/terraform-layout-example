variable "infra_env" {
  type        = string
  description = "infrastructure environment variable"
  default     = "dev"
}

variable "default_region" {
  type        = string
  description = "the region this infrastructure is in"
  default     = "eu-central-1"
}

variable "instance_size" {
  type        = string
  description = "ec2 web server size"
  default     = "t2.micro"
}

