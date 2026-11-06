output "public_alb_arn" {
  description = "ARN of the public Application Load Balancer"
  value       = aws_lb.public_alb.arn
}

output "public_alb_dns_name" {
  description = "DNS name of the public Application Load Balancer"
  value       = aws_lb.public_alb.dns_name
}

output "public_alb_zone_id" {
  description = "Canonical hosted zone ID of the public ALB"
  value       = aws_lb.public_alb.zone_id
}

output "web_target_group_arn" {
  description = "ARN of the Web EC2 target group"
  value       = aws_lb_target_group.web_target_group.arn
}

output "internal_alb_arn" {
  description = "ARN of the internal Application Load Balancer"
  value       = aws_lb.internal_alb.arn
}

output "internal_alb_dns_name" {
  description = "DNS name of the internal Application Load Balancer"
  value       = aws_lb.internal_alb.dns_name
}

output "app_target_group_arn" {
  description = "ARN of the Application EC2 target group"
  value       = aws_lb_target_group.app_target_group.arn
}