# Database Module

## Overview

This module provisions an Amazon RDS MySQL database in private subnets for the Application Tier.

Database credentials are retrieved from AWS Secrets Manager instead of being hardcoded in Terraform configuration.

## Resources Created

- AWS Secrets Manager secret
- Secrets Manager secret version
- RDS DB Subnet Group
- Amazon RDS MySQL DB Instance

## Architecture Diagram

```mermaid
flowchart TD
    A[Application Tier EC2] -->|MySQL Port 3306| SG[Database Security Group]
    SG --> RDS[(Amazon RDS MySQL)]
    SM[AWS Secrets Manager] -.->|Database Credentials| A