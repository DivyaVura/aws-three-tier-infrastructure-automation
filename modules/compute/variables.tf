variable "instance_type" {
  description = "EC2 instance type for Web and Application tiers"
  type        = string
  default     = "t3.micro"
}

variable "common_tags" {
  description = "Common tags applied to EC2 instances"
  type        = map(string)
}

variable "web_subnet_ids" {
  description = "Private subnet IDs for Web EC2 instances"
  type        = list(string)
}

variable "app_subnet_ids" {
  description = "Private subnet IDs for Application EC2 instances"
  type        = list(string)
}

variable "web_server_sg_id" {
  description = "Security group ID attached to Web EC2 instances"
  type        = string
}

variable "app_server_sg_id" {
  description = "Security group ID attached to Application EC2 instances"
  type        = string
}

variable "web_target_group_arn" {
  description = "ARN of the Public ALB target group for Web EC2 instances"
  type        = string
}

variable "app_target_group_arn" {
  description = "ARN of the Internal ALB target group for Application EC2 instances"
  type        = string
}

variable "internal_alb_dns_name" {
  description = "DNS name of the Internal ALB used by Web EC2 instances"
  type        = string
}

variable "key_name" {
  description = "Existing AWS EC2 key pair name for SSH access"
  type        = string
}

variable "name_prefix" {
  description = "Prefix used for naming compute resources"
  type        = string
}

variable "db_host" {
  description = "RDS database hostname for the application tier"
  type        = string
}