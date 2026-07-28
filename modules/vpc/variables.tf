variable "project_name" {
  description = "Short project identifier used for naming and tagging."
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)."
  type        = string
}

variable "cidr_block" {
  description = "IPv4 CIDR block for the VPC."
  type        = string
}

variable "availability_zones" {
  description = "List of AZs to spread subnets across."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets. Must align with availability_zones."
  type        = list(string)
  default     = []
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets. Must align with availability_zones."
  type        = list(string)
  default     = []
}

variable "enable_nat_gateway" {
  description = "Create NAT gateway(s) so private subnets can egress to the internet."
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use one NAT gateway shared by all private subnets (cheaper, single AZ failure domain)."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags to apply to every resource in this module."
  type        = map(string)
  default     = {}
}
