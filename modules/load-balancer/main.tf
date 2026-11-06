# Create a public Application Load Balancer
resource "aws_lb" "public_alb" {
  name               = "${var.name_prefix}-public-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [var.public_alb_sg_id]
  subnets         = var.public_subnet_ids

  enable_deletion_protection = false

  tags = merge(var.common_tags, {
    Name = "${var.name_prefix}-public-alb"
    Tier = "Public"
  })
}

# Create a target group for the Web EC2 instances
resource "aws_lb_target_group" "web_target_group" {
  name        = "${var.name_prefix}-web-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    enabled             = true
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(var.common_tags, {
    Name = "${var.name_prefix}-web-target-group"
    Tier = "Web"
  })
}

# Listen for HTTP requests on the Public ALB
resource "aws_lb_listener" "public_alb_listener" {
  load_balancer_arn = aws_lb.public_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_target_group.arn
  }
}

# Create an internal Application Load Balancer
resource "aws_lb" "internal_alb" {
  name               = "${var.name_prefix}-internal-alb"
  internal           = true
  load_balancer_type = "application"

  security_groups = [var.internal_alb_sg_id]
  subnets         = var.app_subnet_ids

  enable_deletion_protection = false

  tags = merge(var.common_tags, {
    Name = "${var.name_prefix}-internal-alb"
    Tier = "Application"
  })
}

# Create a target group for the Application EC2 instances
resource "aws_lb_target_group" "app_target_group" {
  name        = "${var.name_prefix}-app-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    enabled             = true
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(var.common_tags, {
    Name = "${var.name_prefix}-app-target-group"
    Tier = "Application"
  })
}

# Listen for HTTP requests on the Internal ALB
resource "aws_lb_listener" "internal_alb_listener" {
  load_balancer_arn = aws_lb.internal_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_target_group.arn
  }
}