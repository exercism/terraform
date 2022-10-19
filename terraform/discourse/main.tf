variable "region" {}
variable "aws_vpc_main" {}
variable "aws_subnet_publics" {}
variable "acm_certificate_arn" {}

provider "aws" {
  region  = var.region
}

provider "aws" {
  region = "us-east-1"
  alias  = "global"
}


# Fetch AZs in the current region
data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

locals {
  aws_account_id     = data.aws_caller_identity.current.account_id
}
