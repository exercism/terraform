variable "region" {}
variable "aws_ecr_repository_webserver_rails" {}
variable "aws_iam_policy_document_assume_role_ecs" {}
variable "aws_iam_policy_read_dynamodb_config" {}
variable "aws_iam_policy_write_to_cloudwatch" {}
variable "aws_iam_policy_access_s3_bucket_submissions" {}
variable "aws_iam_policy_access_s3_bucket_tooling_jobs" {}
variable "aws_iam_policy_access_s3_attachments" {}
variable "aws_iam_policy_access_s3_uploads" {}
variable "aws_iam_role_ecs_task_execution" {}
variable "aws_iam_policy_read_secret_config" {}
variable "aws_iam_policy_invalidate_cloudfront_assets" {}
variable "aws_security_group_rds_main" {}
variable "aws_security_group_efs_repositories_access" {}
variable "aws_security_group_efs_submissions_access" {}
variable "aws_security_group_elasticache_anycable" {}
variable "aws_security_group_elasticache_tooling_jobs" {}
variable "aws_security_group_es_general" {}
variable "aws_efs_file_system_repositories" {}
variable "aws_efs_file_system_submissions" {}
variable "efs_submissions_mount_point" {}
variable "efs_repositories_mount_point" {}

variable "aws_vpc_main" {}
variable "aws_subnet_publics" {}

variable "container_cpu" {}
variable "container_memory" {}
variable "container_count" {}
variable "monitor_port" {}

provider "aws" {
  region  = var.region
}

# Fetch AZs in the current region
data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}
