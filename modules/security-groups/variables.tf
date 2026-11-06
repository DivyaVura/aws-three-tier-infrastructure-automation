variable "vpc_id" {
  description = "ID of the VPC where security groups will be created"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to security groups"
  type        = map(string)
}

variable "anywhere_cidr" {
  description = "CIDR block representing all IPv4 addresses"
  type        = string
  default     = "0.0.0.0/0"
}

variable "allowed_admin_cidr" {
  description = "CIDR block representing the approved admin IP address"
  type        = string
}