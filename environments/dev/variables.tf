variable "aws_region" {
  description = "AWS region for infrastructure deployment"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Name of the infrastructure project"
  type        = string
  default     = "aws-three-tier-infrastructure-automation"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Project owner"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones for deployment"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "web_subnet_cidrs" {
  description = "CIDR blocks for Web tier subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "app_subnet_cidrs" {
  description = "CIDR blocks for Application tier subnets"
  type        = list(string)
  default     = ["10.0.21.0/24", "10.0.22.0/24"]
}

variable "db_subnet_cidrs" {
  description = "CIDR blocks for Database tier subnets"
  type        = list(string)
  default     = ["10.0.31.0/24", "10.0.32.0/24"]
}

variable "instance_type" {
  description = "EC2 instance type for Web and Application tiers"
  type        = string
  default     = "t3.micro"
}

variable "allowed_admin_cidr" {
  description = "Approved administrator public IP range for SSH"
  type        = string

  validation {
    condition     = can(cidrhost(var.allowed_admin_cidr, 0))
    error_message = "Provide a valid IPv4 CIDR block, such as 203.0.113.10/32."
  }
}

variable "domain_name" {
  description = "Domain name registered with GoDaddy"
  type        = string
}

variable "key_name" {
  description = "Existing AWS EC2 key pair name"
  type        = string
}
