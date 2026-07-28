variable "project_name" {
  description = "Short project identifier used for naming and tagging."
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)."
  type        = string
}

variable "name" {
  description = "Short purpose of the SG (e.g. web, alb, db)."
  type        = string
}

variable "description" {
  description = "Free-form description of the security group."
  type        = string
  default     = "Managed by Terraform"
}

variable "vpc_id" {
  description = "VPC in which to create the security group."
  type        = string
}

variable "ingress_rules" {
  description = <<-EOT
    List of inbound rules. Each item:
      {
        description = optional(string)
        from_port   = number
        to_port     = number
        protocol    = string        # "tcp", "udp", "icmp", or "-1"
        cidr_blocks = list(string)  # single-element list (one CIDR per rule)
      }
  EOT
  type = list(object({
    description = optional(string)
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "egress_rules" {
  description = <<-EOT
    List of outbound rules (same shape as ingress_rules).
    If empty (default), the module creates a single allow-all-egress rule.
  EOT
  type = list(object({
    description = optional(string)
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "tags" {
  description = "Additional tags to apply to the security group."
  type        = map(string)
  default     = {}
}
