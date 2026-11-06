# Create a DB subnet group across both Availability Zones
resource "aws_db_subnet_group" "database_subnet_group" {
  name        = "${var.name_prefix}-db-subnet-group"
  description = "Private DB subnets for the three-tier architecture"

  subnet_ids = var.database_subnet_ids

  tags = merge(var.common_tags, {
    Name = "${var.name_prefix}-db-subnet-group"
    Tier = "Database"
  })
}

# Create a private MySQL RDS database
resource "aws_db_instance" "mysql_database" {
  identifier = "${var.name_prefix}-mysql-db"

  engine         = "mysql"
  engine_version = var.mysql_engine_version
  instance_class = var.db_instance_class

  allocated_storage = 20
  storage_type      = "gp3"
  storage_encrypted = true

  db_name  = var.database_name
  username = local.db_credentials.username
  password = local.db_credentials.password
  port     = 3306

  db_subnet_group_name   = aws_db_subnet_group.database_subnet_group.name
  vpc_security_group_ids = [var.database_sg_id]

  publicly_accessible = false
  multi_az            = false

  backup_retention_period = 1
  skip_final_snapshot     = true
  deletion_protection     = false

  tags = merge(var.common_tags, {
    Name = "${var.name_prefix}-mysql-db"
    Tier = "Database"
  })
}