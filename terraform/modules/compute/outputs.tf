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

output "autoscaling_group_name" {
  description = "Name of the application Auto Scaling Group"
  value       = aws_autoscaling_group.app.name
}

output "launch_template_id" {
  description = "ID of the EC2 launch template"
  value       = aws_launch_template.app.id
}

output "alb_arn_suffix" {
  description = "ARN suffix of the Application Load Balancer"
  value       = aws_lb.app.arn_suffix
}

output "target_group_arn_suffix" {
  description = "ARN suffix of the ALB target group"
  value       = aws_lb_target_group.app.arn_suffix
}