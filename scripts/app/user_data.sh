#!/bin/bash
set -e

# Update packages and install dependencies
apt update -y
apt install -y nginx python3-venv python3-pip

# Create application directory
mkdir -p /opt/student-app

# Copy application source code
cat > /opt/student-app/app.py <<'PY'
${app_source}
PY

cat > /opt/student-app/requirements.txt <<'REQ'
${requirements}
REQ

# Configure Python virtual environment
python3 -m venv /opt/student-app/venv
/opt/student-app/venv/bin/pip install --upgrade pip
/opt/student-app/venv/bin/pip install -r /opt/student-app/requirements.txt

# Configure database hostname
cat > /etc/student-app.env <<'ENV'
DB_HOST="${db_host}"
ENV
chmod 600 /etc/student-app.env

# Create systemd service for Flask
cat > /etc/systemd/system/student-app.service <<'SERVICE'
[Unit]
Description=Student Records Flask Application
After=network.target

[Service]
User=www-data
WorkingDirectory=/opt/student-app
EnvironmentFile=/etc/student-app.env
ExecStart=/opt/student-app/venv/bin/python /opt/student-app/app.py
Restart=always

[Install]
WantedBy=multi-user.target
SERVICE

chown -R www-data:www-data /opt/student-app

# Configure Nginx as reverse proxy to Flask
cat > /etc/nginx/sites-available/default <<'NGINX'
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    server_name _;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
NGINX

# Start services
systemctl daemon-reload
systemctl enable student-app
systemctl restart student-app
systemctl enable nginx
systemctl restart nginx
