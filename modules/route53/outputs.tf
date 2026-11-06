output "hosted_zone_id" {
  description = "ID of the Route 53 public hosted zone"
  value       = aws_route53_zone.public_hosted_zone.zone_id
}

output "name_servers" {
  description = "Route 53 nameservers assigned to the hosted zone"
  value       = aws_route53_zone.public_hosted_zone.name_servers
}