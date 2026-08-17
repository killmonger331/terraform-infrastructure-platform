# ---------------------------------------------------------
# ALB Security Group
# ---------------------------------------------------------

resource "aws_security_group" "alb" {
  name        = "terraform-platform-${var.environment}-alb-sg"
  description = "Allow HTTP and HTTPS traffic from the internet"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name        = "terraform-platform-${var.environment}-alb-sg"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"

  description = "Allow HTTP from the internet"
}

resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  security_group_id = aws_security_group.alb.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"

  description = "Allow HTTPS from the internet"
}


# ---------------------------------------------------------
# EC2 Security Group
# ---------------------------------------------------------

resource "aws_security_group" "ec2" {
  name        = "terraform-platform-${var.environment}-ec2-sg"
  description = "Allow application traffic only from the ALB"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name        = "terraform-platform-${var.environment}-ec2-sg"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ec2_from_alb" {
  security_group_id = aws_security_group.ec2.id

  referenced_security_group_id = aws_security_group.alb.id

  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"

  description = "Allow HTTP traffic from ALB"
}


# ---------------------------------------------------------
# RDS Security Group
# ---------------------------------------------------------

resource "aws_security_group" "rds" {
  name        = "terraform-platform-${var.environment}-rds-sg"
  description = "Allow MySQL traffic only from EC2 instances"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name        = "terraform-platform-${var.environment}-rds-sg"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "rds_from_ec2" {
  security_group_id = aws_security_group.rds.id

  referenced_security_group_id = aws_security_group.ec2.id

  from_port   = 3306
  to_port     = 3306
  ip_protocol = "tcp"

  description = "Allow MySQL traffic from EC2"
}

# ---------------------------------------------------------
# Outbound Rules
# ---------------------------------------------------------

resource "aws_vpc_security_group_egress_rule" "alb_outbound" {
  security_group_id = aws_security_group.alb.id

  referenced_security_group_id = aws_security_group.ec2.id

  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"

  description = "Allow ALB traffic to EC2"
}

resource "aws_vpc_security_group_egress_rule" "ec2_outbound_rds" {
  security_group_id = aws_security_group.ec2.id

  referenced_security_group_id = aws_security_group.rds.id

  from_port   = 3306
  to_port     = 3306
  ip_protocol = "tcp"

  description = "Allow EC2 database traffic to RDS"
}

resource "aws_vpc_security_group_egress_rule" "ec2_outbound_internet" {
  security_group_id = aws_security_group.ec2.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  description = "Allow EC2 outbound internet access through NAT Gateway"
}