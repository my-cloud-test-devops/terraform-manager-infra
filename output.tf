output "alb_endpoint" {
  description = "ALB DNS Name"
  value       = aws_lb.demo_alb.dns_name
}

output "rds_endpoint" {
  description = "RDS Endpoint"
  value       = aws_db_instance.demo_rds_instance.endpoint
}