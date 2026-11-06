# Security Groups Module

## Overview

This module creates Security Groups to control inbound and outbound traffic between the different tiers of the AWS three-tier architecture.

It uses Security Group references to restrict communication between application components.

## Security Groups Created

- Public ALB Security Group
- Web Server Security Group
- Internal ALB Security Group
- Application Server Security Group
- Database Security Group

## Inbound Rules

| Security Group | Port | Source |
|---|---:|---|
| Public ALB | 80, 443 | Internet (`0.0.0.0/0`) |
| Web Server | 80 | Public ALB Security Group |
| Web Server | 22 | Administrator IP (`/32`) |
| Internal ALB | 80 | Web Server Security Group |
| Application Server | 80 | Internal ALB Security Group |
| Application Server | 22 | Administrator IP (`/32`) |
| Database | 3306 | Application Server Security Group |

## Security Design

- Internet traffic enters through the Public ALB.
- Web Servers accept HTTP traffic only from the Public ALB.
- The Internal ALB accepts traffic only from the Web Tier.
- Application Servers accept HTTP traffic only from the Internal ALB.
- The RDS database accepts MySQL traffic only from the Application Tier.
- SSH access is restricted to the administrator's public IP address.

## Input Variables

- `vpc_id`
- `common_tags`
- `allowed_admin_cidr`

## Outputs

- `public_alb_sg_id`
- `web_server_sg_id`
- `internal_alb_sg_id`
- `app_server_sg_id`
- `database_sg_id`

## Notes

- Port 443 is allowed in the Public ALB Security Group, but an HTTPS listener is not configured yet.
- HTTPS configuration is pending DNS delegation and ACM certificate setup.
- This module is currently used by the Dev environment.