variable "region" {}
variable "ecr_tooling_repos" {}

# variable "aws_account_id" {}
# variable "aws_iam_policy_write_to_cloudwatch" {}
# variable "aws_iam_role_ecs_task_execution" {}
variable "aws_iam_policy_read_dynamodb_config_arn" {}
variable "aws_iam_policy_read_dynamodb_tooling_language_groups_arn" {}
variable "aws_iam_policy_write_s3_bucket_tooling_jobs" {}

variable "aws_vpc_main" {}
variable "aws_subnet_publics" {}

provider "aws" {
  region  = var.region
  version = "~> 2.64"
}

data "aws_caller_identity" "current" {}
locals {
  aws_account_id = data.aws_caller_identity.current.account_id
}

