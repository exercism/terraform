variable "region" {}
variable "aws_iam_policy_document_assume_ecs_role" {}
variable "aws_iam_policy_access_dynamodb" {}
variable "aws_iam_policy_write_to_cloudwatch" {}

provider "aws" {
  region  = var.region
  profile = "exercism_terraform"
  version = "~> 2.64"
}
