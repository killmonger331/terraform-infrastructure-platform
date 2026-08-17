output "rds_endpoint" {
  description = "Endpoint of the RDS MySQL database"
  value       = aws_db_instance.main.address
}

output "rds_port" {
  description = "Port used by the RDS MySQL database"
  value       = aws_db_instance.main.port
}

output "rds_database_name" {
  description = "Name of the application database"
  value       = aws_db_instance.main.db_name
}

output "db_instance_identifier" {
  description = "Identifier of the RDS database instance"
  value       = aws_db_instance.main.identifier
}