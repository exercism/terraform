variable "region" {}
variable "aws_account_id" {}
variable "aws_subnet_publics" {}
variable "aws_efs_mount_target_tooling_jobs" {}
variable "aws_efs_access_point_tooling_jobs" {}
variable "aws_security_group_efs_tooling_jobs_access" {}
variable "aws_alb_listener_internal" {}
variable "efs_tooling_jobs_mount_point" {}

provider "aws" {
  region  = var.region
}

data "aws_caller_identity" "current" {}
locals {
  aws_account_id = data.aws_caller_identity.current.account_id
  username       = "lambda-public-write-user"
  function_name = "lines_of_code_counter"
}
