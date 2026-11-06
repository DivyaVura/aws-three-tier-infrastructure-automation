variable "name_prefix" {
  description = "Prefix used for naming database resources"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to database resources"
  type        = map(string)
}

variable "database_subnet_ids" {
  description = "Private subnet IDs for the RDS database"
  type        = list(string)
}

variable "database_sg_id" {
  description = "Security group ID attached to the RDS database"
  type        = string
}

variable "database_name" {
  description = "Initial MySQL database name"
  type        = string
  default     = "threetierdb"
}

variable "mysql_engine_version" {
  description = "MySQL engine version for RDS"
  type        = string
  default     = "8.0"
}

variable "db_instance_class" {
  description = "RDS DB instance class"
  type        = string
  default     = "db.t3.micro"
}