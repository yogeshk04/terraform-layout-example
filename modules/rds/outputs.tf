output "db_instance_id" {
  description = "ID of the RDS instance."
  value       = aws_db_instance.this.id
}

output "db_instance_arn" {
  description = "ARN of the RDS instance."
  value       = aws_db_instance.this.arn
}

output "db_endpoint" {
  description = "Connection endpoint (host:port)."
  value       = aws_db_instance.this.endpoint
}

output "db_address" {
  description = "Hostname of the DB endpoint."
  value       = aws_db_instance.this.address
}

output "db_port" {
  description = "Port the DB listens on."
  value       = aws_db_instance.this.port
}

output "security_group_id" {
  description = "ID of the security group protecting the DB."
  value       = aws_security_group.this.id
}
