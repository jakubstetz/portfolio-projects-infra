#!/bin/bash
# This script runs automatically when EC2 instance boots if provided as User Data
# It sets up the EC2 instance with everything needed to deploy portfolio project backends and microservices with domain and HTTPS routing

# Redirect output to log file
exec > /var/log/user-data.log 2>&1
set -x # Print each command as it is executed

# Wait until network connectivity is established
until ping -c1 github.com &>/dev/null; do
  echo "Waiting for network..."
  sleep 5
done

# System prep
dnf update -y
dnf install -y git nginx docker python3-pip

# Set up Docker
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

# Install Go
GO_VERSION=1.24.4
cd /usr/local
curl -LO https://golang.org/dl/go$GO_VERSION.linux-amd64.tar.gz
rm -rf go
tar -C /usr/local -xzf go$GO_VERSION.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> /etc/profile
echo 'export PATH=$PATH:/usr/local/go/bin' >> /home/ec2-user/.bashrc
export PATH=$PATH:/usr/local/go/bin

# Clone project repos from GitHub
cd /home/ec2-user
curl -L https://raw.githubusercontent.com/jakubstetz/portfolio-projects-infra/main/scripts/repos.txt \
  -o repos.txt
while read -r repo_url; do
  if [ -n "$repo_url" ]; then
    echo "Cloning $repo_url..."
    git clone "$repo_url"
  fi
done < repos.txt

# NGINX reverse proxy setup
cd portfolio-insights-backend/.infra
cp nginx_portfolio-insights.conf /etc/nginx/conf.d/portfolio-insights.conf
cd ../
cd resume-scanner/.infra
cp nginx_resume-scanner.conf /etc/nginx/conf.d/resume-scanner.conf
systemctl enable nginx
systemctl restart nginx

# Certbot setup information message
echo ""
echo "Because first-time use of Certbot requires user interaction, SSL setup with Certbot is not included as a part of this script."

# Set ownership of cloned repositories, to ensure they're not owned by root
chown -R ec2-user:ec2-user /home/ec2-user

# Completion message
echo ""
echo "✅ EC2 setup complete."
echo "Run backend.yaml workflow in GitHub Actions to deploy backend, and then visit https://api.portfolio-insights.jakubstetz.dev/health and https://api.resume-scanner.jakubstetz.dev/health to check system health."
echo "Run microservice.yaml workflow in GitHub Actions to deploy microservice."
echo ""