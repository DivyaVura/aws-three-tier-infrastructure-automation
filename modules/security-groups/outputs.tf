output "public_alb_sg_id" {
  description = "ID of the Public ALB security group"
  value       = aws_security_group.public_alb_sg.id
}

output "web_server_sg_id" {
  description = "ID of the Web EC2 security group"
  value       = aws_security_group.web_server_sg.id
}

output "internal_alb_sg_id" {
  description = "ID of the Internal ALB security group"
  value       = aws_security_group.internal_alb_sg.id
}

output "app_server_sg_id" {
  description = "ID of the Application EC2 security group"
  value       = aws_security_group.app_server_sg.id
}

output "database_sg_id" {
  description = "ID of the Database security group"
  value       = aws_security_group.database_sg.id
}