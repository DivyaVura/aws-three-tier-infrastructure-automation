variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "anywhere_cidr" {
  description = "CIDR block representing all IPv4 destinations"
  type        = string
  default     = "0.0.0.0/0"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "name_prefix" {
  description = "Prefix used for AWS resource names"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to networking resources"
  type        = map(string)
}

variable "availability_zones" {
  description = "Availability zones for subnet placement"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "web_subnet_cidrs" {
  description = "CIDR blocks for private web subnets"
  type        = list(string)
}

variable "app_subnet_cidrs" {
  description = "CIDR blocks for private application subnets"
  type        = list(string)
}

variable "db_subnet_cidrs" {
  description = "CIDR blocks for private database subnets"
  type        = list(string)
}