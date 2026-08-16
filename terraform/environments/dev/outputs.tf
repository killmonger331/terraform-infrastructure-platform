#value Terraform exposes after deployment 

#output "test_bucket_name" {
#  description = "Name of the Terraform test S3 bucket"
#  value       = aws_s3_bucket.terraform_test.id
#}

output "vpc_id" {
  description = "ID of the development VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block of the development VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"

  value = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]
}

output "private_app_subnet_ids" {
  description = "IDs of the private application subnets"

  value = [
    aws_subnet.private_app_a.id,
    aws_subnet.private_app_b.id
  ]
}

output "private_db_subnet_ids" {
  description = "IDs of the private database subnets"

  value = [
    aws_subnet.private_db_a.id,
    aws_subnet.private_db_b.id
  ]
}

output "alb_security_group_id" {
  description = "Security group ID for the Application Load Balancer"
  value       = aws_security_group.alb.id
}

output "ec2_security_group_id" {
  description = "Security group ID for application EC2 instances"
  value       = aws_security_group.ec2.id
}

output "rds_security_group_id" {
  description = "Security group ID for the RDS database"
  value       = aws_security_group.rds.id
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.app.dns_name
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.app.arn
}

output "target_group_arn" {
  description = "ARN of the application target group"
  value       = aws_lb_target_group.app.arn
}