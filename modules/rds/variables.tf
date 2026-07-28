variable "project_name" {
  description = "Short project identifier used for naming and tagging."
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)."
  type        = string
}

variable "name" {
  description = "Short name for this database (e.g. app, analytics)."
  type        = string
}

variable "vpc_id" {
  description = "VPC the RDS instance belongs to."
  type        = string
}

variable "subnet_ids" {
  description = "Private subnets (at least two, in different AZs) for the DB subnet group."
  type        = list(string)
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to connect to the database on `port`."
  type        = list(string)
  default     = []
}

variable "engine" {
  description = "Database engine (e.g. mysql, postgres)."
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "Engine version."
  type        = string
  default     = "8.0"
}

variable "instance_class" {
  description = "DB instance class."
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Allocated storage in GB."
  type        = number
  default     = 20
}

variable "storage_type" {
  description = "Storage type."
  type        = string
  default     = "gp3"
}

variable "db_name" {
  description = "Initial database name to create."
  type        = string
}

variable "username" {
  description = "Master username."
  type        = string
}

variable "password" {
  description = "Master password. Provide via a secret manager or CI variable \u2014 never commit."
  type        = string
  sensitive   = true
}

variable "port" {
  description = "Port the DB engine listens on."
  type        = number
  default     = 3306
}

variable "multi_az" {
  description = "Deploy in multiple AZs."
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Number of days to retain backups (0 disables)."
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "Preferred backup window (UTC)."
  type        = string
  default     = "03:00-04:00"
}

variable "skip_final_snapshot" {
  description = "Skip taking a final snapshot on destroy (usually only safe in dev)."
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Prevent accidental deletion of the DB instance."
  type        = bool
  default     = true
}

variable "apply_immediately" {
  description = "Apply changes immediately instead of at the next maintenance window."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags to apply to every resource in this module."
  type        = map(string)
  default     = {}
}
