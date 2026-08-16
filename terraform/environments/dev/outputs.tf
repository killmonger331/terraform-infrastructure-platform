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

