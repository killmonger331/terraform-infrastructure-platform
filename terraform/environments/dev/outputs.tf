output "vpc_id" {
  description = "ID of the development VPC"
  value       = module.networking.vpc_id
}

output "vpc_cidr" {
  description = "CIDR block of the development VPC"
  value       = module.networking.vpc_cidr
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.networking.public_subnet_ids
}

output "private_app_subnet_ids" {
  description = "IDs of the private application subnets"
  value       = module.networking.private_app_subnet_ids
}

output "private_db_subnet_ids" {
  description = "IDs of the private database subnets"
  value       = module.networking.private_db_subnet_ids
}

output "alb_security_group_id" {
  description = "Security group ID for the Application Load Balancer"
  value       = module.networking.alb_security_group_id
}

output "ec2_security_group_id" {
  description = "Security group ID for application EC2 instances"
  value       = module.networking.ec2_security_group_id
}

output "rds_security_group_id" {
  description = "Security group ID for the RDS database"
  value       = module.networking.rds_security_group_id
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.compute.alb_dns_name
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = module.compute.alb_arn
}

output "target_group_arn" {
  description = "ARN of the application target group"
  value       = module.compute.target_group_arn
}

output "rds_endpoint" {
  description = "Endpoint of the RDS MySQL database"
  value       = module.database.rds_endpoint
}

output "rds_port" {
  description = "Port used by the RDS MySQL database"
  value       = module.database.rds_port
}

output "rds_database_name" {
  description = "Name of the application database"
  value       = module.database.rds_database_name
}

output "cloudwatch_dashboard_name" {
  description = "Name of the infrastructure CloudWatch dashboard"
  value       = module.monitoring.cloudwatch_dashboard_name
}

