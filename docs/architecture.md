# AWS Three-Tier Architecture

## Project Overview

This project implements a three-tier architecture on AWS using Terraform. The infrastructure is deployed in the Dev environment in the Mumbai region (`ap-south-1`).

## Architecture Diagram

```mermaid
flowchart TD
    U[Internet Users] --> P[Public ALB]
    P --> W[Web Tier - Auto Scaling Group]
    W --> I[Internal ALB]
    I --> A[Application Tier - Auto Scaling Group]
    A --> R[(Amazon RDS MySQL)]