module "networking" {
  source = "../../modules/networking"

  name_prefix        = local.name_prefix
  vpc_cidr           = var.vpc_cidr
  environment        = var.environment
  common_tags        = local.common_tags
  availability_zones = var.availability_zones

  public_subnet_cidrs = var.public_subnet_cidrs
  web_subnet_cidrs    = var.web_subnet_cidrs
  app_subnet_cidrs    = var.app_subnet_cidrs
  db_subnet_cidrs     = var.db_subnet_cidrs
}

module "security_groups" {
  source = "../../modules/security-groups"

  vpc_id             = module.networking.vpc_id
  common_tags        = local.common_tags
  allowed_admin_cidr = var.allowed_admin_cidr
}

module "load_balancer" {
  source = "../../modules/load-balancer"

  name_prefix = local.name_prefix
  common_tags = local.common_tags

  # Networking module outputs
  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
  app_subnet_ids    = module.networking.app_subnet_ids

  # Security Groups module outputs
  public_alb_sg_id   = module.security_groups.public_alb_sg_id
  internal_alb_sg_id = module.security_groups.internal_alb_sg_id
}

module "compute" {
  source = "../../modules/compute"

  name_prefix   = local.name_prefix
  instance_type = var.instance_type
  key_name      = var.key_name
  common_tags   = local.common_tags

  # Networking module outputs
  web_subnet_ids = module.networking.web_subnet_ids
  app_subnet_ids = module.networking.app_subnet_ids

  # Security Groups module outputs
  web_server_sg_id = module.security_groups.web_server_sg_id
  app_server_sg_id = module.security_groups.app_server_sg_id

  # Load Balancer module outputs
  web_target_group_arn = module.load_balancer.web_target_group_arn
  app_target_group_arn = module.load_balancer.app_target_group_arn

  internal_alb_dns_name = module.load_balancer.internal_alb_dns_name
  db_host               = module.database.database_address
}

module "database" {
  source = "../../modules/database"

  name_prefix = local.name_prefix
  common_tags = local.common_tags

  # Networking module outputs
  database_subnet_ids = module.networking.database_subnet_ids

  # Security Groups module outputs
  database_sg_id = module.security_groups.database_sg_id

  # Database configuration
  database_name        = "threetierdb"
  mysql_engine_version = "8.0"
  db_instance_class    = "db.t3.micro"
}

# Create Route 53 hosted zone and point the domain to the Public ALB
module "route53" {
  source = "../../modules/route53"

  domain_name = var.domain_name
  name_prefix = local.name_prefix
  common_tags = local.common_tags

  public_alb_dns_name = module.load_balancer.public_alb_dns_name
  public_alb_zone_id  = module.load_balancer.public_alb_zone_id
}