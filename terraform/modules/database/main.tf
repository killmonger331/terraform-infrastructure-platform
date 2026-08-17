# ---------------------------------------------------------
# RDS DB Subnet Group
# ---------------------------------------------------------

resource "aws_db_subnet_group" "main" {
  name = "terraform-platform-${var.environment}-db-subnet-group"

  subnet_ids = var.private_db_subnet_ids

  tags = {
    Name        = "terraform-platform-${var.environment}-db-subnet-group"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}


# ---------------------------------------------------------
# RDS MySQL Instance
# ---------------------------------------------------------

resource "aws_db_instance" "main" {
  identifier = "terraform-platform-${var.environment}-db"

  engine         = "mysql"
  instance_class = "db.t3.micro"

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = "platformdb"
  username = "platformadmin"

  manage_master_user_password = true

  db_subnet_group_name = aws_db_subnet_group.main.name

  vpc_security_group_ids = [
    var.rds_security_group_id
  ]

  multi_az            = true
  publicly_accessible = false

  backup_retention_period = 7

  skip_final_snapshot = true
  deletion_protection = false

  tags = {
    Name        = "terraform-platform-${var.environment}-db"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}