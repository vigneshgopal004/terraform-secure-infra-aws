output "alb_dns_name" {
  description = "Public DNS name of the Application Load Balancer"
  value       = aws_lb.alb.dns_name
}

output "ec2_instance_id" {
  description = "Private EC2 instance ID (SSM access)"
  value       = aws_instance.app.id
}

output "rds_endpoint" {
  description = "Private RDS endpoint"
  value       = aws_db_instance.db.endpoint
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}
