# Route 53 Module

## Overview

This module creates a public Amazon Route 53 hosted zone for the project domain and configures an alias record pointing to the Public Application Load Balancer.

## Resources Created

- Route 53 Public Hosted Zone
- Route 53 A Record with ALB Alias

## Architecture Diagram

```mermaid
flowchart TD
    U[Internet User] --> D[Project Domain]
    D --> R[Route 53 Hosted Zone]
    R -->|A Record Alias| ALB[Public Application Load Balancer]
    ALB --> W[Web Tier]