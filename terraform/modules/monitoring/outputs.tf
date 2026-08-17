output "cloudwatch_dashboard_name" {
  description = "Name of the infrastructure CloudWatch dashboard"
  value       = aws_cloudwatch_dashboard.main.dashboard_name
}