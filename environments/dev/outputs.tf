
# Networking Outputs
output "vpc_id" {
  description = "ID of the three-tier VPC"
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.networking.public_subnet_ids
}

output "web_private_subnet_ids" {
  description = "IDs of the private web subnets"
  value       = module.networking.web_subnet_ids
}

output "app_private_subnet_ids" {
  description = "IDs of the private application subnets"
  value       = module.networking.app_subnet_ids
}

output "database_private_subnet_ids" {
  description = "IDs of the private database subnets"
  value       = module.networking.database_subnet_ids
}

# Load Balancer Outputs
output "public_alb_dns_name" {
  description = "DNS name of the public Application Load Balancer"
  value       = module.load_balancer.public_alb_dns_name
}

output "internal_alb_dns_name" {
  description = "DNS name of the internal Application Load Balancer"
  value       = module.load_balancer.internal_alb_dns_name
}

# Compute Outputs
output "web_asg_name" {
  description = "Name of the Web Tier Auto Scaling Group"
  value       = module.compute.web_asg_name
}

output "app_asg_name" {
  description = "Name of the Application Tier Auto Scaling Group"
  value       = module.compute.app_asg_name
}

output "web_launch_template_id" {
  description = "Web Tier Launch Template ID"
  value       = module.compute.web_launch_template_id
}

output "app_launch_template_id" {
  description = "Application Tier Launch Template ID"
  value       = module.compute.app_launch_template_id
}

# Database Outputs
output "database_endpoint" {
  description = "Endpoint of the private MySQL RDS database"
  value       = module.database.database_endpoint
}

# Route 53 Outputs
output "hosted_zone_id" {
  description = "ID of the Route 53 public hosted zone"
  value       = module.route53.hosted_zone_id
}

output "route53_name_servers" {
  description = "Nameservers assigned to the Route 53 hosted zone"
  value       = module.route53.name_servers
}
