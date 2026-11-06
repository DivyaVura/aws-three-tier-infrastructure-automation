# Networking Module

## Overview

This module creates the network infrastructure required for the AWS three-tier architecture.

It provides an isolated VPC with public and private subnets distributed across two Availability Zones.

## Resources Created

- VPC
- Public subnets
- Private Web Tier subnets
- Private Application Tier subnets
- Private Database subnets
- Internet Gateway
- NAT Gateways
- Elastic IP addresses for NAT Gateways
- Public and private route tables
- Route table associations

## Network Design

| Network Component | CIDR Range |
|---|---|
| VPC | 10.0.0.0/16 |
| Public Subnets | 10.0.1.0/24, 10.0.2.0/24 |
| Web Subnets | 10.0.11.0/24, 10.0.12.0/24 |
| Application Subnets | 10.0.21.0/24, 10.0.22.0/24 |
| Database Subnets | 10.0.31.0/24, 10.0.32.0/24 |

## Network Flow

- Public subnets use the Internet Gateway for internet connectivity.
- Private subnets use NAT Gateways for outbound internet access.
- Web, Application, and Database tiers are placed in separate private subnets.
- Each tier is distributed across two Availability Zones.

## Input Variables

- `name_prefix`
- `vpc_cidr`
- `environment`
- `common_tags`
- `availability_zones`
- `public_subnet_cidrs`
- `web_subnet_cidrs`
- `app_subnet_cidrs`
- `db_subnet_cidrs`

## Outputs

- `vpc_id`
- `public_subnet_ids`
- `web_subnet_ids`
- `app_subnet_ids`
- `database_subnet_ids`

## Environment

This module is currently used by the Dev environment.