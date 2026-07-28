variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version to deploy."
  type        = string
  default     = "1.29"
}

variable "subnet_ids" {
  description = "Subnets (at least two, in different AZs) for the cluster and nodes. Typically private subnets."
  type        = list(string)
}

variable "endpoint_public_access" {
  description = "Whether the cluster's Kubernetes API endpoint is reachable from the public internet."
  type        = bool
  default     = true
}

variable "endpoint_private_access" {
  description = "Whether the cluster's Kubernetes API endpoint is reachable from within the VPC."
  type        = bool
  default     = true
}

variable "public_access_cidrs" {
  description = "CIDR blocks allowed to reach the public API endpoint. Restrict this in production."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "node_groups" {
  description = <<-EOT
    Map of managed node group definitions, keyed by node group name. Each value:
      {
        instance_types = list(string)   # e.g. ["t3.medium"]
        min_size       = number
        max_size       = number
        desired_size   = number
        capacity_type  = string          # optional: "ON_DEMAND" (default) or "SPOT"
        labels         = map(string)     # optional
      }
  EOT
  type = map(object({
    instance_types = list(string)
    min_size       = number
    max_size       = number
    desired_size   = number
    capacity_type  = optional(string, "ON_DEMAND")
    labels         = optional(map(string), {})
  }))
  default = {}
}

variable "tags" {
  description = "Additional tags to apply to every resource in this module."
  type        = map(string)
  default     = {}
}
