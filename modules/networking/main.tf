resource "aws_vpc" "three_tier_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.common_tags, {
    Name = "${var.name_prefix}-vpc"
  })
}

# Public Subnets
resource "aws_subnet" "public" {
  count = length(var.availability_zones)

  vpc_id                  = aws_vpc.three_tier_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.common_tags, {
    Name = "public-subnet-${var.availability_zones[count.index]}"
    Tier = "Public"
  })
}

# Private Web Subnets
resource "aws_subnet" "web" {
  count = length(var.availability_zones)

  vpc_id            = aws_vpc.three_tier_vpc.id
  cidr_block        = var.web_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(var.common_tags, {
    Name = "web-private-subnet-${var.availability_zones[count.index]}"
    Tier = "Web"
  })
}

# Private App Subnets
resource "aws_subnet" "app" {
  count = length(var.availability_zones)

  vpc_id            = aws_vpc.three_tier_vpc.id
  cidr_block        = var.app_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(var.common_tags, {
    Name = "app-private-subnet-${var.availability_zones[count.index]}"
    Tier = "Application"
  })
}

# Private Database Subnets
resource "aws_subnet" "database" {
  count = length(var.availability_zones)

  vpc_id            = aws_vpc.three_tier_vpc.id
  cidr_block        = var.db_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(var.common_tags, {
    Name = "database-private-subnet-${var.availability_zones[count.index]}"
    Tier = "Database"
  })
}

# Internet Gateway
resource "aws_internet_gateway" "three_tier_igw" {
  vpc_id = aws_vpc.three_tier_vpc.id

  tags = merge(var.common_tags, {
  Name = "three-tier-${var.environment}-internet-gateway" })
}

# Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.three_tier_vpc.id

  route {
    cidr_block = var.anywhere_cidr
    gateway_id = aws_internet_gateway.three_tier_igw.id
  }

  tags = merge(var.common_tags, {
    Name = "three-tier-${var.environment}-public-route-table"
  })
}

# Public Subnet Route Table Associations
resource "aws_route_table_association" "public_subnet_association" {
  count = length(var.availability_zones)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

# Elastic IPs for NAT Gateways
resource "aws_eip" "nat_eip" {
  count  = length(var.availability_zones)
  domain = "vpc"

  tags = merge(var.common_tags, {
    Name = "nat-gateway-eip-${var.availability_zones[count.index]}"
  })
}

# NAT Gateways
resource "aws_nat_gateway" "nat_gateway" {
  count = length(var.availability_zones)

  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(var.common_tags, {
    Name = "nat-gateway-${var.availability_zones[count.index]}"
  })

  depends_on = [
    aws_internet_gateway.three_tier_igw
  ]
}

# Private Web Route Tables
resource "aws_route_table" "web_route_table" {
  count = length(var.availability_zones)

  vpc_id = aws_vpc.three_tier_vpc.id

  route {
    cidr_block     = var.anywhere_cidr
    nat_gateway_id = aws_nat_gateway.nat_gateway[count.index].id
  }

  tags = merge(var.common_tags, {
    Name = "web-private-route-table-${var.availability_zones[count.index]}"
    Tier = "Web"
  })
}

# Web Subnet Route Table Associations
resource "aws_route_table_association" "web_subnet_association" {
  count = length(var.availability_zones)

  subnet_id      = aws_subnet.web[count.index].id
  route_table_id = aws_route_table.web_route_table[count.index].id
}

# Private App Route Tables
resource "aws_route_table" "app_route_table" {
  count = length(var.availability_zones)

  vpc_id = aws_vpc.three_tier_vpc.id

  route {
    cidr_block     = var.anywhere_cidr
    nat_gateway_id = aws_nat_gateway.nat_gateway[count.index].id
  }

  tags = merge(var.common_tags, {
    Name = "app-private-route-table-${var.availability_zones[count.index]}"
    Tier = "Application"
  })
}

# App Subnet Route Table Associations
resource "aws_route_table_association" "app_subnet_association" {
  count = length(var.availability_zones)

  subnet_id      = aws_subnet.app[count.index].id
  route_table_id = aws_route_table.app_route_table[count.index].id
}

# Private Database Route Table
resource "aws_route_table" "database_route_table" {
  vpc_id = aws_vpc.three_tier_vpc.id

  tags = merge(var.common_tags, {
    Name = "database-private-route-table"
    Tier = "Database"
  })
}

# Database Subnet Route Table Associations
resource "aws_route_table_association" "database_subnet_association" {
  count = length(var.availability_zones)

  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database_route_table.id
}