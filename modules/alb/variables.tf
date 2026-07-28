variable "project_name" {
  description = "Short project identifier used for naming and tagging."
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)."
  type        = string
}

variable "name" {
  description = "Short name for the load balancer (e.g. web)."
  type        = string
}

variable "vpc_id" {
  description = "VPC the load balancer belongs to."
  type        = string
}

variable "subnet_ids" {
  description = "Subnets the load balancer will be placed in (at least two in different AZs)."
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security groups attached to the load balancer."
  type        = list(string)
}

variable "internal" {
  description = "Set to true for an internal ALB (not internet-facing)."
  type        = bool
  default     = false
}

variable "enable_deletion_protection" {
  description = "Prevent accidental deletion of the load balancer."
  type        = bool
  default     = false
}

variable "target_ids" {
  description = "List of target IDs (EC2 instance IDs, IPs, or Lambda ARNs) to register."
  type        = list(string)
  default     = []
}

variable "target_type" {
  description = "Target type: instance, ip, lambda, or alb."
  type        = string
  default     = "instance"
}

variable "target_port" {
  description = "Port targets listen on."
  type        = number
  default     = 80
}

variable "target_protocol" {
  description = "Protocol used to talk to targets."
  type        = string
  default     = "HTTP"
}

variable "listener_port" {
  description = "Port the load balancer listens on."
  type        = number
  default     = 80
}

variable "listener_protocol" {
  description = "Protocol the load balancer listens on. Use HTTPS in production."
  type        = string
  default     = "HTTP"
}

variable "certificate_arn" {
  description = "ACM certificate ARN. Required if listener_protocol is HTTPS."
  type        = string
  default     = null
}

variable "ssl_policy" {
  description = "SSL policy for the HTTPS listener."
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

variable "health_check_path" {
  description = "Health check path."
  type        = string
  default     = "/"
}

variable "health_check_interval" {
  description = "Health check interval in seconds."
  type        = number
  default     = 30
}

variable "health_check_timeout" {
  description = "Health check timeout in seconds."
  type        = number
  default     = 5
}

variable "health_check_healthy_threshold" {
  description = "Consecutive successes needed to consider a target healthy."
  type        = number
  default     = 3
}

variable "health_check_unhealthy_threshold" {
  description = "Consecutive failures needed to consider a target unhealthy."
  type        = number
  default     = 3
}

variable "health_check_matcher" {
  description = "HTTP response code matcher for health checks."
  type        = string
  default     = "200"
}

variable "tags" {
  description = "Additional tags to apply to every resource in this module."
  type        = map(string)
  default     = {}
}
