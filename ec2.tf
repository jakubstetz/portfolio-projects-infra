resource "aws_instance" "portfolio_projects" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  # Configure root block device
  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
    encrypted   = true
    
    tags = merge(local.common_tags, {
      Name = "portfolio-projects-root-volume"
    })
  }

  user_data = file("scripts/user_data.sh")

  # Recreate the EC2 instance if the user_data script changes,
  # since user_data only runs on first boot and can't be updated in-place
  user_data_replace_on_change = true

  tags = merge(local.common_tags, {
    Name = "portfolio-projects-ec2"
  })
}