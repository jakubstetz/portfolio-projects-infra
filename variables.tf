variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

# EC2 Configuration
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of an existing EC2 key pair"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "ec2_allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access the EC2 instance"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Restrict this in production!
}

variable "root_volume_size" {
  description = "Size of the root volume in GB"
  type        = number
  default     = 8
}

variable "root_volume_type" {
  description = "Type of the root volume (e.g., gp3, gp2, io1)"
  type        = string
  default     = "gp3"
}

# RDS Configuration
variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t4g.micro"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "portfolio-insights"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "db_storage_gb" {
  description = "Database storage size in GB"
  type        = number
  default     = 20
}

variable "db_backup_retention_days" {
  description = "Number of days to retain database backups"
  type        = number
  default     = 7
}