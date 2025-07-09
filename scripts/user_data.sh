#!/bin/bash
# This script runs automatically when EC2 instance boots if provided as User Data
# It sets up the EC2 instance with everything needed to deploy portfolio project backends and microservices with domain and HTTPS routing

# Redirect output to log file
exec > /var/log/user-data.log 2>&1
set -x # Print each command as it is executed

# Wait until network connectivity is established
echo ""
echo "⌛ Waiting for network..."

until ping -c1 github.com &>/dev/null; do
  sleep 5
done

echo ""
echo "✅ Network connection established."

# System prep
echo ""
echo "📦 Installing necessary dnf packages..."
dnf update -y
dnf install -y git nginx docker python3-pip postgresql17 gettext

git --version
nginx --version
docker --version
python3 --version # Present by default on Amazon Linux
pip3 --version
psql --version
gettext --version

# Install yq
echo ""
echo "🛠️ Installing yq..."
YQ_VERSION="v4.43.1"
curl -L "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64" -o /usr/local/bin/yq
chmod +x /usr/local/bin/yq

yq --version

# Install Go
echo ""
echo "🐀 Installing and configuring Go..."
GO_VERSION=1.24.4
cd /usr/local
curl -LO https://golang.org/dl/go$GO_VERSION.linux-amd64.tar.gz
tar -C /usr/local -xzf go$GO_VERSION.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' > /etc/profile.d/go.sh
chmod +x /etc/profile.d/go.sh

go --version

# Set up Docker
echo ""
echo "🐳 Setting up Docker..."
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

# Move to home directory and set ownership of cloned repositories to ensure they're not owned by root
cd /home/ec2-user
chown -R ec2-user:ec2-user /home/ec2-user

# Download utility files needed for setup
echo ""
echo "⚙️ Downloading utility files needed for setup..."
curl -L https://raw.githubusercontent.com/jakubstetz/portfolio-projects-infra/main/scripts/projects.yaml \
  -o projects.yaml
curl -L https://raw.githubusercontent.com/jakubstetz/portfolio-projects-infra/main/scripts/nginx_template.conf \
  -o nginx_template.conf

# Verify that project information is available
echo ""
echo "🔍 Verifying project structure in projects.yaml..."
if ! yq -e '.projects[].services[]' projects.yaml > /dev/null; then
  echo "❌ No services found in projects.yaml. Check formatting." >&2
  exit 1
fi

# Clone project repos from GitHub and set up NGINX reverse proxies
yq -e '.projects[].services[]' projects.yaml | while read -r service; do
  echo ""

  # Extract fields from service
  repo=$(echo "$service" | yq -r '.repo')
  port=$(echo "$service" | yq -r '.port')
  domain=$(echo "$service" | yq -r '.domain')
  name=$(basename "$repo" .git)

  echo "🧬 Cloning $repo..."
  git clone "$repo"

  echo "🛜 Generating NGINX config for $name ($domain)..."
  export port domain
  envsubst < nginx_template.conf > "/etc/nginx/conf.d/${name}.conf"

  echo ""
done

nginx -t # Verify valid NGINX configuration

echo ""
echo "🌐 Restarting NGINX..."
systemctl enable nginx
systemctl restart nginx

# Certbot setup information messages
echo ""
echo "🔐 To enable HTTPS, run the following commands after DNS is configured:"

yq -r '.projects[].services[].domain' projects.yaml | while read -r domain; do
  echo "  sudo certbot --nginx -d $domain"
done

# Remove unnecessary utility files used for setup
echo "🧹 Removing utility files used for setup..."
rm -f nginx_template.conf
rm -f go$GO_VERSION.linux-amd64.tar.gz

# Completion message
echo ""
echo "✅ EC2 setup complete."
echo "Run backend.yaml workflow in GitHub Actions to deploy backend, and then visit https://api.portfolio-insights.jakubstetz.dev/health and https://api.resume-scanner.jakubstetz.dev/health to check system health."
echo "Run microservice.yaml workflow in GitHub Actions to deploy microservice."
echo ""