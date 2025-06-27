#!/bin/bash

# This command will get the latest official AMI ID for Amazon Linux 2023
echo ""

echo "Latest AMI ID for Amazon Linux 2023:"

aws ssm get-parameters-by-path \
  --path /aws/service/ami-amazon-linux-latest \
  --region us-east-1 \
  --query "Parameters[?Name=='/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-arm64'].Value" \
  --output text

echo ""