data "aws_vpc" "default" {
  default = true
}

locals {
  common_tags = {
    Project     = "portfolio-projects"
    ManagedBy   = "terraform"
  }
}
