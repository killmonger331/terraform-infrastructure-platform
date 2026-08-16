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