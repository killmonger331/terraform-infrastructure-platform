variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID used by the target group"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs used by the ALB"
  type        = list(string)
}

variable "private_app_subnet_ids" {
  description = "Private application subnet IDs used by the Auto Scaling Group"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security group ID for the Application Load Balancer"
  type        = string
}

variable "ec2_security_group_id" {
  description = "Security group ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "min_size" {
  description = "Minimum Auto Scaling Group size"
  type        = number
  default     = 2
}

variable "desired_capacity" {
  description = "Desired Auto Scaling Group capacity"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum Auto Scaling Group size"
  type        = number
  default     = 4
}