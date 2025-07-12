# Fetch default VPC subnets
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Define RDS subnet group from those subnets
resource "aws_db_subnet_group" "default" {
  name       = "default-subnet-group"
  subnet_ids = data.aws_subnets.default.ids

  tags = {
    Name = "Default RDS Subnet Group"
  }
}

resource "aws_db_instance" "portfolio_projects_db" {
  identifier = "portfolio-projects"
  
  engine         = "postgres"
  engine_version = "17.4"
  instance_class = var.db_instance_class
  
  allocated_storage = var.db_storage_gb
  storage_type      = var.db_storage_type
  storage_encrypted = true
  
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group.default.name
  
  backup_retention_period = var.db_backup_retention_days
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"
  
  skip_final_snapshot = true  # For dev environments
  deletion_protection = false # For dev environments
  
  tags = {
    Name = "portfolio-insights-db"
  }
}