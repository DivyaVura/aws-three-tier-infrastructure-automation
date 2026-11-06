variable "name_prefix" {
  description = "Prefix used for naming load balancer resources"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to load balancer resources"
  type        = map(string)
}

variable "vpc_id" {
  description = "ID of the VPC where target groups will be created"
  type        = string
}

variable "public_subnet_ids" {
  description = "IDs of public subnets for the internet-facing ALB"
  type        = list(string)
}

variable "app_subnet_ids" {
  description = "IDs of private application subnets for the internal ALB"
  type        = list(string)
}

variable "public_alb_sg_id" {
  description = "Security group ID attached to the public ALB"
  type        = string
}

variable "internal_alb_sg_id" {
  description = "Security group ID attached to the internal ALB"
  type        = string
}