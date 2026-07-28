output "lb_arn" {
  description = "ARN of the load balancer."
  value       = aws_lb.this.arn
}

output "lb_dns_name" {
  description = "Public DNS name of the load balancer."
  value       = aws_lb.this.dns_name
}

output "lb_zone_id" {
  description = "Route 53 hosted zone ID of the load balancer (for alias records)."
  value       = aws_lb.this.zone_id
}

output "target_group_arn" {
  description = "ARN of the default target group."
  value       = aws_lb_target_group.this.arn
}

output "listener_arn" {
  description = "ARN of the default listener."
  value       = aws_lb_listener.this.arn
}
