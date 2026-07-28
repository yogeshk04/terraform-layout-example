variable "project_name" {
  description = "Short project identifier used for naming and tagging."
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)."
  type        = string
}

variable "name" {
  description = "Short role/purpose for this instance (e.g. web, bastion)."
  type        = string
}

variable "ami_id" {
  description = "AMI ID to launch."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Subnet to launch the instance in."
  type        = string
}

variable "vpc_security_group_ids" {
  description = "Security group IDs to attach to the instance."
  type        = list(string)
}

variable "key_name" {
  description = "Name of an existing EC2 key pair. Set to null to skip."
  type        = string
  default     = null
}

variable "user_data" {
  description = "User data script for the instance."
  type        = string
  default     = null
}

variable "associate_public_ip_address" {
  description = "Assign an auto-public-IP at launch."
  type        = bool
  default     = false
}

variable "allocate_eip" {
  description = "Allocate and associate an Elastic IP."
  type        = bool
  default     = false
}

variable "root_volume_size" {
  description = "Root EBS volume size in GB."
  type        = number
  default     = 8
}

variable "root_volume_type" {
  description = "Root EBS volume type."
  type        = string
  default     = "gp3"
}

variable "tags" {
  description = "Additional tags to apply to every resource in this module."
  type        = map(string)
  default     = {}
}
