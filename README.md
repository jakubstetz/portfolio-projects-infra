# 📦 Portfolio Insights Infrastructure

This repository defines the AWS infrastructure for the Portfolio Insights project using Terraform. It provisions an EC2 instance and RDS database, with all resources codified for reproducibility and ease of use.

## 🚀 What It Does

- Provisions an EC2 instance running:
  - Docker
  - Go
  - NGINX
  - Cloned backend and microservice repos

- Provisions an RDS PostgreSQL database

- Configures security groups for EC2 and RDS

- Bootstraps EC2 with user_data.sh

- Outputs key connection values

## 📁 Repository Structure
```
.
├── ec2.tf                   # EC2 instance + user_data
├── rds.tf                   # RDS PostgreSQL instance
├── security_groups.tf       # EC2 and RDS security rules
├── variables.tf             # Terraform input variables
├── terraform.tfvars         # (local-only) real values, .gitignored
├── terraform.tfvars.example # Safe-to-commit example values
├── outputs.tf               # Useful outputs like public IP
├── provider.tf              # AWS provider setup
├── scripts/
│   └── user_data.sh         # Shell script run on EC2 boot
└── README.md
```

## ✅ Prerequisites

- Terraform CLI

- AWS CLI configured with IAM credentials

- SSH key pair already uploaded to AWS (key_name matches)

- Backend and microservice repos accessible by EC2

## 🛠️ Usage

1. Clone this repo:
```
git clone https://github.com/jakubstetz/portfolio-insights-infra.git
cd portfolio-insights-infra
```

2. Create your secrets file:
```
cp terraform.tfvars.example terraform.tfvars
```

3. Edit `terraform.tfvars` with real values

4. Initialize Terraform:
```
terraform init
```

5. Review and apply:
```
terraform plan
terraform apply
```

## 🔍 Post-Provision

- SSH into the instance:
```
ssh -i path/to/your-key.pem ec2-user@<public_ip>
```

- Check provisioning logs:
```
cat /var/log/user-data.log
```

- Run GitHub Actions workflows to deploy backend and microservice