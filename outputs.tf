output "ec2_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.portfolio_insights.public_ip
}

output "ec2_public_dns" {
  description = "The public DNS name of the EC2 instance"
  value       = aws_instance.portfolio_insights.public_dns
}

output "ec2_private_ip" {
  description = "The private IP address of the EC2 instance"
  value       = aws_instance.portfolio_insights.private_ip
}