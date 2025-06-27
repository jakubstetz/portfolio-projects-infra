#!/bin/bash

# This script will initialize Terraform, plan, and apply the infrastructure
echo ""
echo "Initializing Terraform..."
terraform init
echo ""
echo "Planning..."
terraform plan
echo ""
echo "Applying..."
terraform apply
echo ""