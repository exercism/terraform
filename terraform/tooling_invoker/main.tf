variable "region" {}
variable "ecr_tooling_repos" {}

# variable "aws_account_id" {}
# variable "aws_iam_policy_write_to_cloudwatch" {}
# variable "aws_iam_role_ecs_task_execution" {}
variable "aws_iam_policy_read_dynamodb_config_arn" {}
variable "aws_iam_policy_read_dynamodb_tooling_language_groups_arn" {}
variable "aws_iam_policy_write_s3_bucket_tooling_jobs" {}
variable "aws_security_group_efs_repositories_access" {}
variable "aws_security_group_efs_tooling_jobs_access" {}
variable "aws_security_group_elasticache_git_cache_access" {}
variable "aws_cloudwatch_log_stream_jobs_general" {}

variable "aws_vpc_main" {}
variable "aws_subnet_publics" {}

provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {}
locals {
  aws_account_id = data.aws_caller_identity.current.account_id
}

