# Security Group Rules

This project uses separate Security Groups to control communication between the different tiers of the AWS three-tier architecture.

## 1. Public ALB Security Group

| Rule | Port | Source | Purpose |
|---|---:|---|---|
| HTTP | 80 | Anywhere (`0.0.0.0/0`) | Allows users to access the application through the Public ALB |
| HTTPS | 443 | Anywhere (`0.0.0.0/0`) | Allows HTTPS traffic when HTTPS is configured |

## 2. Web Server Security Group

| Rule | Port | Source | Purpose |
|---|---:|---|---|
| HTTP | 80 | Public ALB Security Group | Allows HTTP traffic from the Public ALB |
| SSH | 22 | Administrator's public IP (`/32`) | Allows restricted administrative access |

## 3. Internal ALB Security Group

| Rule | Port | Source | Purpose |
|---|---:|---|---|
| HTTP | 80 | Web Server Security Group | Allows requests from the Web Tier |

## 4. App Server Security Group

| Rule | Port | Source | Purpose |
|---|---:|---|---|
| HTTP | 80 | Internal ALB Security Group | Allows requests from the Internal ALB |
| SSH | 22 | Administrator's public IP (`/32`) | Allows restricted administrative access |

## 5. Database Security Group

| Rule | Port | Source | Purpose |
|---|---:|---|---|
| MySQL | 3306 | App Server Security Group | Allows database connections from the App Tier |

## Security Design

- The Public ALB accepts HTTP traffic from the internet.
- Web Servers accept HTTP traffic only from the Public ALB.
- The Internal ALB accepts traffic only from the Web Tier.
- App Servers accept HTTP traffic only from the Internal ALB.
- The RDS database accepts MySQL connections only from the App Tier.
- SSH access is restricted to the administrator's public IP address.
- Security Group references are used between tiers to control internal communication.

## Notes

- The Public ALB Security Group has an inbound rule for port 443, but an HTTPS listener is not configured yet.
- HTTPS configuration is pending DNS delegation and ACM certificate setup.
- This documentation describes the Dev environment only.