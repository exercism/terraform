variable "region" {}
variable "aws_vpc_main" {}
variable "aws_account_id" {}
variable "aws_subnet_lambda" {}
variable "aws_alb_listener_internal" {}
variable "aws_iam_policy_read_dynamodb_config" {}

provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}
locals {
  aws_account_id           = data.aws_caller_identity.current.account_id
  lambda_public_write_user = "lambda-public-write-user"
  function_name            = "translator"
}
