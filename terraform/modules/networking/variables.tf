variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}
variable "public_subnet_a_cidr" {
  description = "CIDR block for public subnet A"
  type        = string
}

variable "public_subnet_b_cidr" {
  description = "CIDR block for public subnet B"
  type        = string
}

variable "private_app_subnet_a_cidr" {
  description = "CIDR block for private application subnet A"
  type        = string
}

variable "private_app_subnet_b_cidr" {
  description = "CIDR block for private application subnet B"
  type        = string
}

variable "private_db_subnet_a_cidr" {
  description = "CIDR block for private database subnet A"
  type        = string
}

variable "private_db_subnet_b_cidr" {
  description = "CIDR block for private database subnet B"
  type        = string
}