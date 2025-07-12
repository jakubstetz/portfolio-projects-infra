output "ec2_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.portfolio_projects.public_ip
}

output "ec2_public_dns" {
  description = "The public DNS name of the EC2 instance"
  value       = aws_instance.portfolio_projects.public_dns
}

output "ec2_private_ip" {
  description = "The private IP address of the EC2 instance"
  value       = aws_instance.portfolio_projects.private_ip
}

output "rds_endpoint" {
  description = "The RDS instance endpoint"
  value       = aws_db_instance.portfolio_projects_db.endpoint
}

output "rds_port" {
  description = "The RDS instance port"
  value       = aws_db_instance.portfolio_projects_db.port
}