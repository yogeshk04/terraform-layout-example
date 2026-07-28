variable "project_name" {
  description = "Short project identifier used for naming and tagging."
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)."
  type        = string
}

variable "name" {
  description = "Short name for the ASG (e.g. web)."
  type        = string
}

variable "ami_id" {
  description = "AMI ID for launch template."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of an existing EC2 key pair. Set to null to skip."
  type        = string
  default     = null
}

variable "security_group_ids" {
  description = "Security groups to attach to launched instances."
  type        = list(string)
}

variable "subnet_ids" {
  description = "Subnets in which the ASG will place instances."
  type        = list(string)
}

variable "target_group_arns" {
  description = "Optional list of target group ARNs to register instances with."
  type        = list(string)
  default     = []
}

variable "min_size" {
  description = "Minimum number of instances."
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances."
  type        = number
  default     = 3
}

variable "desired_capacity" {
  description = "Desired number of instances."
  type        = number
  default     = 1
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

variable "user_data" {
  description = "User data script (plain text, base64-encoded automatically)."
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional tags to apply to every resource in this module."
  type        = map(string)
  default     = {}
}
