variable "region" {}
variable "aws_account_id" {}
variable "aws_subnet_publics" {}
variable "aws_efs_mount_target_submissions" {}
variable "aws_efs_access_point_submissions" {}
variable "aws_security_group_efs_submissions_access" {}
variable "aws_alb_listener_internal" {}

provider "aws" {
  region  = var.region
}

data "aws_caller_identity" "current" {}
locals {
  aws_account_id = data.aws_caller_identity.current.account_id
  username       = "lambda-public-write-user"
  function_name = "image_generator"
}
