# Deployment Guide

## Prerequisites

Before deploying the infrastructure, make sure you have:

- An AWS account.
- AWS CLI installed and configured.
- Terraform installed.
- Appropriate AWS IAM permissions.
- An existing EC2 key pair.
- A registered domain name (for Route 53 configuration).

## Project Configuration

1. Clone or download this repository.
2. Navigate to the Dev environment directory:

```powershell
cd environments/dev