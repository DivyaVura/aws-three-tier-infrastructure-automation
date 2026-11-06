
# IAM role allowing Web EC2 instances to use Systems Manager
resource "aws_iam_role" "ec2_ssm_role" {
  name = "${var.name_prefix}-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_ssm_profile" {
  name = "${var.name_prefix}-ec2-ssm-profile"
  role = aws_iam_role.ec2_ssm_role.name

  tags = var.common_tags
}

# IAM role for Application Tier EC2 instances
resource "aws_iam_role" "app_ec2_role" {
  name = "${var.name_prefix}-app-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = var.common_tags
}

# Allow App EC2 instances to use Systems Manager
resource "aws_iam_role_policy_attachment" "app_ssm" {
  role       = aws_iam_role.app_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Find the existing RDS credentials secret
data "aws_secretsmanager_secret" "rds_credentials" {
  name = "rds/terraform/credentials"
}

# Allow App EC2 instances to retrieve RDS credentials only
resource "aws_iam_role_policy" "app_secrets_read" {
  name = "${var.name_prefix}-app-secrets-read"
  role = aws_iam_role.app_ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["secretsmanager:GetSecretValue"]
      Resource = data.aws_secretsmanager_secret.rds_credentials.arn
    }]
  })
}

# App EC2 instance profile
resource "aws_iam_instance_profile" "app_ec2_profile" {
  name = "${var.name_prefix}-app-ec2-profile"
  role = aws_iam_role.app_ec2_role.name

  tags = var.common_tags
}

# Find the latest Ubuntu Server 24.04 LTS AMI
data "aws_ami" "ubuntu_2404" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# Web Tier Launch Template
resource "aws_launch_template" "web" {
  name_prefix   = "${var.name_prefix}-web-"
  image_id      = data.aws_ami.ubuntu_2404.id
  instance_type = var.instance_type
  key_name      = var.key_name

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_ssm_profile.name
  }

  vpc_security_group_ids = [var.web_server_sg_id]

  user_data = base64encode(templatefile("${path.root}/../../scripts/web/user_data.sh", {
    internal_alb_dns_name = var.internal_alb_dns_name
  }))

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size           = 8
      volume_type           = "gp3"
      encrypted             = true
      delete_on_termination = true
    }
  }

  credit_specification {
    cpu_credits = "standard"
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(var.common_tags, {
      Name = "${var.name_prefix}-web-instance"
      Tier = "Web"
    })
  }

  update_default_version = true

  depends_on = [
    aws_iam_role_policy_attachment.ssm_managed_instance_core
  ]
}

# Application Tier Launch Template
resource "aws_launch_template" "app" {
  name_prefix   = "${var.name_prefix}-app-"
  image_id      = data.aws_ami.ubuntu_2404.id
  instance_type = var.instance_type
  key_name      = var.key_name

  iam_instance_profile {
    name = aws_iam_instance_profile.app_ec2_profile.name
  }

  vpc_security_group_ids = [var.app_server_sg_id]

  user_data = base64encode(templatefile("${path.root}/../../scripts/app/user_data.sh", {
    db_host      = var.db_host
    app_source   = file("${path.root}/../../app/app.py")
    requirements = file("${path.root}/../../app/requirements.txt")
  }))

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size           = 8
      volume_type           = "gp3"
      encrypted             = true
      delete_on_termination = true
    }
  }

  credit_specification {
    cpu_credits = "standard"
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(var.common_tags, {
      Name = "${var.name_prefix}-app-instance"
      Tier = "Application"
    })
  }

  update_default_version = true

  depends_on = [
    aws_iam_role_policy_attachment.app_ssm,
    aws_iam_role_policy.app_secrets_read
  ]
}

# Web Tier Auto Scaling Group
resource "aws_autoscaling_group" "web" {
  name                = "${var.name_prefix}-web-asg"
  min_size            = 2
  desired_capacity    = 2
  max_size            = 4
  vpc_zone_identifier = var.web_subnet_ids

  target_group_arns         = [var.web_target_group_arn]
  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.web.id
    version = aws_launch_template.web.latest_version
  }

  dynamic "tag" {
    for_each = merge(var.common_tags, {
      Name = "${var.name_prefix}-web-instance"
      Tier = "Web"
    })

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.ssm_managed_instance_core
  ]
}

# Application Tier Auto Scaling Group
resource "aws_autoscaling_group" "app" {
  name                = "${var.name_prefix}-app-asg"
  min_size            = 2
  desired_capacity    = 2
  max_size            = 4
  vpc_zone_identifier = var.app_subnet_ids

  target_group_arns         = [var.app_target_group_arn]
  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.app.id
    version = aws_launch_template.app.latest_version
  }

  dynamic "tag" {
    for_each = merge(var.common_tags, {
      Name = "${var.name_prefix}-app-instance"
      Tier = "Application"
    })

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.app_ssm,
    aws_iam_role_policy.app_secrets_read
  ]
}
