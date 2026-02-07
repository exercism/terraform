variable "region" {}
variable "cloudflare_ipv4_ranges" {}
variable "cloudflare_ipv6_ranges" {}

variable "ecr_tooling_repos" {}
variable "aws_iam_policy_document_assume_role_ecs" {}
variable "aws_iam_policy_read_dynamodb_config" {}
variable "aws_iam_policy_write_to_cloudwatch" {}
variable "aws_iam_policy_access_s3_bucket_submissions" {}
variable "aws_iam_policy_access_s3_bucket_tooling_jobs" {}
variable "aws_iam_policy_access_s3_attachments" {}
variable "aws_iam_policy_access_s3_uploads" {}
variable "aws_iam_role_ecs_task_execution" {}
variable "aws_iam_policy_read_secret_config" {}
variable "aws_iam_policy_ses_suppression" {}
variable "aws_security_group_elasticache_anycable" {}
variable "aws_security_group_elasticache_sidekiq" {}
variable "aws_security_group_rds_main" {}
variable "aws_security_group_efs_repositories_access" {}
variable "aws_security_group_efs_cache_access" {}
variable "aws_security_group_efs_tooling_jobs_access" {}
variable "aws_security_group_elasticache_tooling_jobs" {}
variable "aws_security_group_es_general" {}
variable "aws_security_group_internal_alb" {}
variable "aws_efs_file_system_repositories" {}
variable "aws_efs_file_system_cache" {}
variable "aws_efs_file_system_tooling_jobs" {}
variable "aws_redis_url_anycable" {}
variable "aws_ecr_repository_anycable_go" {}
variable "aws_ecr_repository_anycable_go_pro" {}
variable "aws_alb_listener_internal" {}

variable "efs_cache_mount_point" {}
variable "efs_repositories_mount_point" {}
variable "efs_tooling_jobs_mount_point" {}

variable "route53_zone_main" {}
variable "acm_certificate_arn" {}

variable "aws_vpc_main" {}
variable "aws_subnet_publics" {}

variable "website_protocol" {}
variable "website_host" {}
variable "http_port" {}
variable "websockets_port" {}

variable "service_api_cpu" {}
variable "service_api_memory" {}
variable "service_api_count" {}

variable "service_website_cpu" {}
variable "service_website_memory" {}
variable "service_website_count" {}

variable "service_anycable_cpu" {}
variable "service_anycable_memory" {}
variable "service_anycable_count" {}

provider "aws" {
  region = var.region
}

provider "aws" {
  region = "us-east-1"
  alias  = "global"
}


# Fetch AZs in the current region
data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

locals {
  aws_account_id = data.aws_caller_identity.current.account_id
}
