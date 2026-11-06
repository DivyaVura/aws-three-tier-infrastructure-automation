# Create a public hosted zone for the project domain
resource "aws_route53_zone" "public_hosted_zone" {
  name = var.domain_name

  tags = merge(var.common_tags, {
    Name = "${var.name_prefix}-hosted-zone"
  })
}

# Point the project domain to the Public ALB
resource "aws_route53_record" "public_alb_alias" {
  zone_id = aws_route53_zone.public_hosted_zone.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.public_alb_dns_name
    zone_id                = var.public_alb_zone_id
    evaluate_target_health = true
  }
}