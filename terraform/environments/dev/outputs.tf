#value Terraform exposes after deployment 

output "test_bucket_name" {
  description = "Name of the Terraform test S3 bucket"
  value       = aws_s3_bucket.terraform_test.id
}

