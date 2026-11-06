# Security Groups for ALB and EC2 Instances

# Security Group for Public ALB
resource "aws_security_group" "public_alb_sg" {
  name        = "public-alb-security-group"
  description = "Allow HTTP traffic from the internet to the public ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP traffic from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.anywhere_cidr]
  }

  ingress {
    description = "Allow HTTPS traffic from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.anywhere_cidr]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.anywhere_cidr]
  }

  tags = merge(var.common_tags, {
    Name = "public-alb-security-group"
    Tier = "Public"
  })
}

# Security Group for Web Servers
resource "aws_security_group" "web_server_sg" {
  name        = "web-server-security-group"
  description = "Allow HTTP traffic only from the public ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP from Public ALB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"

    # Allow inbound traffic from resources(public alb) associated with the Public ALB Security Group
    security_groups = [aws_security_group.public_alb_sg.id]
  }

  ingress {
    description = "Allow SSH only from approved admin IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_admin_cidr]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.anywhere_cidr]
  }

  tags = merge(var.common_tags, {
    Name = "web-server-security-group"
    Tier = "Web"
  })
}

# Security Group for Internal ALB
resource "aws_security_group" "internal_alb_sg" {
  name        = "internal-alb-security-group"
  description = "Allow HTTP traffic from Web EC2 instances"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP from Web tier"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"

    # Allow inbound traffic only from Web EC2 instances associated with the Web Server Security Group
    security_groups = [aws_security_group.web_server_sg.id]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.anywhere_cidr]
  }

  tags = merge(var.common_tags, {
    Name = "internal-alb-security-group"
    Tier = "Application"
  })
}

# Security Group for Application Servers
resource "aws_security_group" "app_server_sg" {
  name        = "app-server-security-group"
  description = "Allow HTTP traffic only from the internal ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP from Internal ALB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"

    # Allow HTTP traffic from the Internal Application Load Balancer to the App EC2 instances
    security_groups = [aws_security_group.internal_alb_sg.id]
  }

  ingress {
    description = "Allow SSH only from approved admin IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_admin_cidr]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.anywhere_cidr]
  }

  tags = merge(var.common_tags, {
    Name = "app-server-security-group"
    Tier = "Application"
  })
}

# Security Group for Database Servers
resource "aws_security_group" "database_sg" {
  name        = "database-security-group"
  description = "Allow MySQL traffic only from App EC2 instances"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow MySQL from App tier"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"

    # Allow MySQL traffic from the App EC2 instances to the RDS database
    security_groups = [aws_security_group.app_server_sg.id]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.anywhere_cidr]
  }

  tags = merge(var.common_tags, {
    Name = "database-security-group"
    Tier = "Database"
  })
}