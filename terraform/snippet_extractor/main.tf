variable "region" {}
variable "aws_account_id" {}
variable "aws_alb_listener_internal" {}

provider "aws" {
  region  = var.region
}

data "aws_caller_identity" "current" {}
locals {
  aws_account_id = data.aws_caller_identity.current.account_id
  username       = "lambda-public-write-user"
  function_name = "snippet_extractor"
}
