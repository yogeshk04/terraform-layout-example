output "state_bucket_name" {
  description = "Name of the S3 bucket that holds Terraform state files."
  value       = aws_s3_bucket.tfstate.id
}

output "state_bucket_arn" {
  description = "ARN of the S3 bucket that holds Terraform state files."
  value       = aws_s3_bucket.tfstate.arn
}

output "lock_table_name" {
  description = "Name of the DynamoDB table used for state locking."
  value       = aws_dynamodb_table.tflock.id
}

output "lock_table_arn" {
  description = "ARN of the DynamoDB table used for state locking."
  value       = aws_dynamodb_table.tflock.arn
}

output "region" {
  description = "AWS region where the backend resources live."
  value       = var.region
}
