variable "domain_name" {
  description = "Domain name registered with GoDaddy"
  type        = string
}

variable "name_prefix" {
  description = "Prefix used for naming Route 53 resources"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to Route 53 resources"
  type        = map(string)
}

variable "public_alb_dns_name" {
  description = "DNS name of the Public Application Load Balancer"
  type        = string
}

variable "public_alb_zone_id" {
  description = "Canonical hosted zone ID of the Public ALB"
  type        = string
}