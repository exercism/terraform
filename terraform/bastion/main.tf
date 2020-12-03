variable "region" {}
variable "aws_iam_policy_read_dynamodb_config" {}
variable "aws_iam_policy_access_dynamodb_tooling_jobs" {}
variable "aws_iam_policy_access_s3_bucket_submissions" {}
variable "aws_iam_policy_access_s3_bucket_tooling_jobs" {}
variable "aws_iam_policy_read_secret_config" {}
variable "aws_security_group_efs_repositories_access" {}
variable "aws_security_group_efs_tooling_jobs_access" {}
variable "aws_security_group_ssh" {}
variable "aws_security_group_rds_main" {}
variable "aws_efs_file_system_repositories" {}
variable "aws_efs_file_system_tooling_jobs" {}

variable "aws_vpc_main" {}
variable "aws_subnet_publics" {}

provider "aws" {
  region  = var.region
  version = "~> 2.64"
}

# Fetch AZs in the current region
data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

locals {
  aws_account_id = data.aws_caller_identity.current.account_id
}

