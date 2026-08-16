# ---------------------------------------------------------
# RDS DB Subnet Group
# ---------------------------------------------------------

resource "aws_db_subnet_group" "main" {
  name = "terraform-platform-dev-db-subnet-group"

  subnet_ids = [
    aws_subnet.private_db_a.id,
    aws_subnet.private_db_b.id
  ]

  tags = {
    Name        = "terraform-platform-dev-db-subnet-group"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}


# ---------------------------------------------------------
# RDS MySQL Instance
# ---------------------------------------------------------

resource "aws_db_instance" "main" {
  identifier = "terraform-platform-dev-db"

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
    aws_security_group.rds.id
  ]

  multi_az            = true
  publicly_accessible = false

  backup_retention_period = 7

  skip_final_snapshot = true
  deletion_protection = false

  tags = {
    Name        = "terraform-platform-dev-db"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}