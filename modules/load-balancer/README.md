# Load Balancer Module

## Overview

This module creates two Application Load Balancers (ALBs) to distribute traffic across the Web and Application tiers.

## Resources Created

- Public Application Load Balancer
- Internal Application Load Balancer
- Web Tier Target Group
- Application Tier Target Group
- Public ALB HTTP Listener
- Internal ALB HTTP Listener

## Configuration

| Component | Type | Scheme | Listener Port |
|---|---|---|---:|
| Public ALB | Application Load Balancer | Internet-facing | 80 |
| Internal ALB | Application Load Balancer | Internal | 80 |

### Target Groups

- Web Target Group: forwards HTTP traffic to Web Tier EC2 instances on port 80.
- Application Target Group: forwards HTTP traffic to Application Tier EC2 instances on port 80.
- Both target groups use HTTP health checks on `/` and expect status code `200`.

## Traffic Flow

1. The Public ALB receives HTTP requests from internet users.
2. It forwards requests to healthy Web Tier instances.
3. The Web Tier Nginx reverse proxy forwards requests to the Internal ALB.
4. The Internal ALB forwards requests to healthy Application Tier instances.

## Input Variables

- `name_prefix`
- `common_tags`
- `vpc_id`
- `public_subnet_ids`
- `app_subnet_ids`
- `public_alb_sg_id`
- `internal_alb_sg_id`

## Outputs

- `public_alb_arn`
- `public_alb_dns_name`
- `public_alb_zone_id`
- `web_target_group_arn`
- `internal_alb_arn`
- `internal_alb_dns_name`
- `app_target_group_arn`

## Notes

- Both ALBs currently use HTTP on port 80.
- HTTPS listener configuration is pending DNS delegation and ACM certificate setup.
- This module is currently used by the Dev environment.