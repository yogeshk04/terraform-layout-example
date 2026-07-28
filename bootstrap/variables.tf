variable "project_name" {
  description = "Short project identifier used in tags."
  type        = string
}

variable "region" {
  description = "AWS region in which to create the state bucket and lock table."
  type        = string
}

variable "profile" {
  description = "AWS CLI profile to use for authentication."
  type        = string
  default     = "default"
}

variable "state_bucket_name" {
  description = "Globally-unique S3 bucket name for Terraform state."
  type        = string
}

variable "lock_table_name" {
  description = "DynamoDB table name for Terraform state locking."
  type        = string
  default     = "terraform-locks"
}
