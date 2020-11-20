variable "region" {}
variable "ecr_language_server_repos" {}

variable "aws_account_id" {}
variable "aws_iam_policy_document_assume_role_ecs" {}
variable "aws_iam_policy_read_dynamodb_config" {}
variable "aws_iam_policy_write_to_cloudwatch" {}
variable "aws_iam_role_ecs_task_execution" {}

variable "aws_vpc_main" {}
variable "aws_subnet_publics" {}

variable "http_port" {}
variable "websockets_port" {}

variable "container_cpu" {}
variable "container_memory" {}
variable "container_count" {}

provider "aws" {
  region  = var.region
  version = "~> 2.64"
}

data "aws_caller_identity" "current" {}
locals {
  aws_account_id = data.aws_caller_identity.current.account_id
}
