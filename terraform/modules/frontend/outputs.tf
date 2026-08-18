output "cloudfront_domain_name" {
  description = "HTTPS URL for the Terraform platform frontend"
  value       = aws_cloudfront_distribution.frontend.domain_name
}

output "frontend_bucket_name" {
  description = "S3 bucket containing the frontend"
  value       = aws_s3_bucket.frontend.id
}