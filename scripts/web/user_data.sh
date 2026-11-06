#!/bin/bash
# Update Ubuntu package repositories
apt update -y

# Install Nginx
apt install nginx -y

# Configure Nginx as a reverse proxy to the Internal ALB
cat > /etc/nginx/sites-available/default <<'EOF'
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://${internal_alb_dns_name};
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
EOF

# Test Nginx configuration
nginx -t

# Start Nginx and enable it after reboot
systemctl enable nginx
systemctl restart nginx
