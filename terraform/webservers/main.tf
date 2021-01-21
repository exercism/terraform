variable "region" {}
variable "ecr_tooling_repos" {}
variable "aws_iam_policy_document_assume_role_ecs" {}
variable "aws_iam_policy_read_dynamodb_config" {}
variable "aws_iam_policy_write_to_cloudwatch" {}
variable "aws_iam_policy_access_dynamodb_tooling_jobs" {}
variable "aws_iam_policy_access_s3_bucket_submissions" {}
variable "aws_iam_policy_access_s3_bucket_tooling_jobs" {}
variable "aws_iam_role_ecs_task_execution" {}
variable "aws_iam_policy_read_secret_config" {}
variable "aws_security_group_rds_main" {}
variable "aws_security_group_efs_repositories_access" {}
variable "aws_security_group_efs_submissions_access" {}
variable "aws_efs_file_system_repositories" {}
variable "aws_efs_file_system_submissions" {}

variable "aws_vpc_main" {}
variable "aws_subnet_publics" {}

variable "website_protocol" {}
variable "website_host" {}
variable "http_port" {}
variable "websockets_port" {}

variable "container_cpu" {}
variable "container_memory" {}
variable "container_count" {}

provider "aws" {
  region  = var.region
}

# Fetch AZs in the current region
data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

locals {
  anycable_redis_url = "redis://${aws_elasticache_cluster.anycable.cache_nodes.0.address}:6379/1"
  aws_account_id     = data.aws_caller_identity.current.account_id
}
