output "frontend_url" {
  description = "Public HTTPS frontend URL"
  value       = "https://${module.frontend.cloudfront_domain_name}"
}