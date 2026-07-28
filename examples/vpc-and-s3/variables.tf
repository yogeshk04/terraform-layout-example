variable "project_name" {
  description = "Short project identifier used for naming and tagging."
  type        = string
  default     = "example"
}

variable "region" {
  description = "AWS region."
  type        = string
  default     = "eu-central-1"
}

variable "profile" {
  description = "AWS CLI profile."
  type        = string
  default     = "default"
}

variable "bucket_name" {
  description = "Globally-unique S3 bucket name for the example."
  type        = string
}
