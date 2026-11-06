# Compute Module

## Overview

This module creates the EC2 infrastructure for the Web and Application tiers using Launch Templates and Auto Scaling Groups.

## Resources Created

- IAM Role for EC2 instances
- IAM Instance Profile
- AWS Systems Manager managed instance policy attachment
- Web Tier Launch Template
- Application Tier Launch Template
- Web Tier Auto Scaling Group
- Application Tier Auto Scaling Group

## Architecture Diagram

```mermaid
flowchart TD
    P[Public ALB] --> W[Web Tier Auto Scaling Group]
    W --> I[Internal ALB]
    I --> A[Application Tier Auto Scaling Group]