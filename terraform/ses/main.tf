variable "region" {}
variable "aws_vpc_main" {}
variable "aws_subnet_lambda" {}
variable "aws_iam_policy_read_dynamodb_config" {}

provider "aws" {
  region  = var.region
}

# Fetch AZs in the current region
data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

locals {
  aws_account_id     = data.aws_caller_identity.current.account_id
  events_function_name = "sns-events"
}

