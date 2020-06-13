variable "region" {}
variable "az_count" {}

provider "aws" {
  region  = var.region
  profile = "exercism_terraform"
  version = "~> 2.64"
}

# Fetch AZs in the current region
data "aws_availability_zones" "available" {}
