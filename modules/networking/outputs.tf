output "vpc_id" {
  description = "ID of the three-tier VPC"
  value       = aws_vpc.three_tier_vpc.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "web_subnet_ids" {
  description = "IDs of the private web tier subnets"
  value       = aws_subnet.web[*].id
}

output "app_subnet_ids" {
  description = "IDs of the private application tier subnets"
  value       = aws_subnet.app[*].id
}

output "database_subnet_ids" {
  description = "IDs of the private database tier subnets"
  value       = aws_subnet.database[*].id
}

output "nat_gateway_ids" {
  description = "IDs of the NAT Gateways across Availability Zones"
  value       = aws_nat_gateway.nat_gateway[*].id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.three_tier_igw.id
}