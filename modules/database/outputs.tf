output "database_endpoint" {
  description = "Endpoint address of the RDS MySQL database"
  value       = aws_db_instance.mysql_database.endpoint
}

output "database_address" {
  description = "Hostname of the RDS MySQL database"
  value       = aws_db_instance.mysql_database.address
}

output "database_port" {
  description = "Port used by the RDS MySQL database"
  value       = aws_db_instance.mysql_database.port
}

output "database_name" {
  description = "Name of the initial MySQL database"
  value       = aws_db_instance.mysql_database.db_name
}