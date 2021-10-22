terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

variable "region" {
  default = "eu-west-2"
}

locals {
  website_protocol    = "https"
  website_host        = "exercism.org"
  http_port           = 80
  websockets_protocol = "wss"
  websockets_port     = 80

  acm_certificate_arn = "arn:aws:acm:us-east-1:681735686245:certificate/ec560e0a-f375-4fd7-95c7-969433eed278"

  efs_submissions_mount_point  = "/mnt/efs/submissions"
  efs_repositories_mount_point = "/mnt/efs/repos"

  s3_bucket_assets_name       = "exercism-v3-assets"
  s3_bucket_attachments_name  = "exercism-v3-attachments"
  s3_bucket_icons_name        = "exercism-v3-icons"
  s3_bucket_logs_name         = "exercism-v3-logs"
  s3_bucket_submissions_name  = "exercism-v3-submissions"
  s3_bucket_tooling_jobs_name = "exercism-v3-tooling-jobs"
  s3_bucket_uploads_name      = "exercism-uploads"

  ecr_tooling_repos = toset([
    "bash-analyzer",
    "bash-test-runner",
    "c-test-runner",
    "c-representer",
    "cfml-test-runner",
    "clojure-analyzer",
    "clojure-representer",
    "clojure-test-runner",
    "clojurescript-test-runner",
    "crystal-test-runner",
    "coffeescript-test-runner",
    "common-lisp-analyzer",
    "common-lisp-representer",
    "common-lisp-test-runner",
    "cpp-test-runner",
    "csharp-analyzer",
    "csharp-representer",
    "csharp-test-runner",
    "d-test-runner",
    "dart-test-runner",
    "elixir-analyzer",
    "elixir-representer",
    "elixir-test-runner",
    "elm-analyzer",
    "elm-representer",
    "elm-test-runner",
    "emacs-lisp-test-runner",
    "erlang-analyzer",
    "erlang-test-runner",
    "fortran-test-runner",
    "fsharp-representer",
    "fsharp-test-runner",
    "go-analyzer",
    "go-test-runner",
    "groovy-test-runner",
    "haskell-test-runner",
    "j-representer",
    "j-test-runner",
    "java-analyzer",
    "java-representer",
    "java-test-runner",
    "javascript-analyzer",
    "javascript-representer",
    "javascript-test-runner",
    "julia-test-runner",
    "kotlin-test-runner",
    "lfe-test-runner",
    "lua-test-runner",
    "mips-test-runner",
    "nim-analyzer",
    "nim-test-runner",
    "ocaml-test-runner",
    "perl5-test-runner",
    "php-test-runner",
    "prolog-test-runner",
    "purescript-test-runner",
    "python-analyzer",
    "python-representer",
    "python-test-runner",
    "r-test-runner",
    "racket-test-runner",
    "raku-test-runner",
    "reasonml-test-runner",
    "red-test-runner",
    "ruby-analyzer",
    "ruby-representer",
    "ruby-test-runner",
    "rust-analyzer",
    "rust-representer",
    "rust-test-runner",
    "scala-analyzer",
    "scala-test-runner",
    "scheme-test-runner",
    "sml-test-runner",
    "stub-analyzer",
    "swift-test-runner",
    "tcl-test-runner",
    "typescript-analyzer",
    "typescript-representer",
    "typescript-test-runner",
    "vbnet-test-runner",
    "vimscript-test-runner",
    "wren-representer",
    "wren-test-runner",
    "x86-64-assembly-test-runner"
  ])


  ecr_lambda_repos = toset([
    "snippet-extractor",
    "lines-of-code-counter"
  ])

  ecr_language_server_repos = toset([
    "ruby-language-server"
  ])
}

provider "aws" {
  region = var.region
}

# Fetch AZs in the current region
data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}


module "files" {
  source = "./files"

  bucket_assets_name       = local.s3_bucket_assets_name
  bucket_attachments_name  = local.s3_bucket_attachments_name
  bucket_icons_name        = local.s3_bucket_icons_name
  bucket_logs_name         = local.s3_bucket_logs_name
  bucket_submissions_name  = local.s3_bucket_submissions_name
  bucket_tooling_jobs_name = local.s3_bucket_tooling_jobs_name
  bucket_uploads_name      = local.s3_bucket_uploads_name

  website_protocol = local.website_protocol
  website_host     = local.website_host
}

module "anycable" {
  source = "./anycable"

  aws_vpc_main       = aws_vpc.main
  aws_subnet_publics = aws_subnet.publics
}


module "webservers" {
  source = "./webservers"

  region            = var.region
  ecr_tooling_repos = local.ecr_tooling_repos
  website_protocol  = local.website_protocol
  website_host      = local.website_host

  aws_iam_policy_document_assume_role_ecs      = data.aws_iam_policy_document.assume_role_ecs
  aws_iam_policy_read_dynamodb_config          = aws_iam_policy.read_dynamodb_config
  aws_iam_policy_write_to_cloudwatch           = aws_iam_policy.write_to_cloudwatch
  aws_iam_policy_access_s3_bucket_submissions  = module.files.bucket_submissions_access
  aws_iam_policy_access_s3_bucket_tooling_jobs = module.files.bucket_tooling_jobs_access
  aws_iam_policy_access_s3_attachments         = module.files.bucket_attachments_access
  aws_iam_policy_access_s3_uploads             = module.files.bucket_uploads_access
  aws_iam_policy_read_secret_config            = aws_iam_policy.read_secret_config
  aws_iam_role_ecs_task_execution              = aws_iam_role.ecs_task_execution
  aws_security_group_efs_repositories_access   = aws_security_group.efs_repositories_access
  aws_security_group_efs_submissions_access    = aws_security_group.efs_submissions_access
  aws_security_group_rds_main                  = aws_security_group.rds_main
  aws_security_group_elasticache_sidekiq       = module.sidekiq.security_group_elasticache
  aws_security_group_elasticache_anycable      = module.anycable.security_group_elasticache
  aws_security_group_elasticache_tooling_jobs  = module.tooling.security_group_elasticache_jobs
  aws_efs_file_system_repositories             = aws_efs_file_system.repositories
  aws_efs_file_system_submissions              = aws_efs_file_system.submissions
  efs_submissions_mount_point                  = local.efs_submissions_mount_point
  efs_repositories_mount_point                 = local.efs_repositories_mount_point
  route53_zone_main                            = aws_route53_zone.main
  acm_certificate_arn                          = local.acm_certificate_arn
  aws_redis_url_anycable                       = module.anycable.redis_url
  aws_ecr_repository_anycable_go               = module.anycable.ecr_repository_go

  aws_vpc_main       = aws_vpc.main
  aws_subnet_publics = aws_subnet.publics

  container_cpu    = 2048
  container_memory = 4096
  container_count  = 6

  http_port       = local.http_port
  websockets_port = local.websockets_port
}

module "sidekiq" {
  source = "./sidekiq"

  region = var.region

  aws_ecr_repository_webserver_rails                      = module.webservers.ecr_repository_rails
  aws_iam_policy_document_assume_role_ecs                 = data.aws_iam_policy_document.assume_role_ecs
  aws_iam_policy_read_dynamodb_config                     = aws_iam_policy.read_dynamodb_config
  aws_iam_policy_write_to_cloudwatch                      = aws_iam_policy.write_to_cloudwatch
  aws_iam_policy_access_s3_bucket_submissions             = module.files.bucket_submissions_access
  aws_iam_policy_access_s3_bucket_tooling_jobs            = module.files.bucket_tooling_jobs_access
  aws_iam_policy_access_s3_attachments                    = module.files.bucket_attachments_access
  aws_iam_policy_access_s3_uploads                        = module.files.bucket_uploads_access
  aws_iam_policy_invoke_api_gateway_snippet_extractor     = module.snippet_extractor.iam_policy_invoke
  aws_iam_policy_invoke_api_gateway_lines_of_code_counter = module.lines_of_code_counter.iam_policy_invoke
  aws_iam_policy_read_secret_config                       = aws_iam_policy.read_secret_config
  aws_iam_role_ecs_task_execution                         = aws_iam_role.ecs_task_execution
  aws_security_group_elasticache_anycable                 = module.anycable.security_group_elasticache
  aws_security_group_efs_repositories_access              = aws_security_group.efs_repositories_access
  aws_security_group_efs_submissions_access               = aws_security_group.efs_submissions_access
  aws_security_group_rds_main                             = aws_security_group.rds_main
  aws_security_group_elasticache_tooling_jobs             = module.tooling.security_group_elasticache_jobs
  aws_efs_file_system_repositories                        = aws_efs_file_system.repositories
  aws_efs_file_system_submissions                         = aws_efs_file_system.submissions
  efs_submissions_mount_point                             = local.efs_submissions_mount_point
  efs_repositories_mount_point                            = local.efs_repositories_mount_point

  aws_vpc_main       = aws_vpc.main
  aws_subnet_publics = aws_subnet.publics

  container_cpu    = 1024
  container_memory = 2048
  container_count  = 1
}

module "bastion" {
  source = "./bastion"

  region            = var.region
  ecr_tooling_repos = local.ecr_tooling_repos

  aws_iam_policy_read_dynamodb_config          = aws_iam_policy.read_dynamodb_config
  aws_iam_policy_access_s3_bucket_submissions  = module.files.bucket_submissions_access
  aws_iam_policy_access_s3_bucket_tooling_jobs = module.files.bucket_tooling_jobs_access
  aws_iam_policy_read_secret_config            = aws_iam_policy.read_secret_config
  aws_security_group_efs_repositories_access   = aws_security_group.efs_repositories_access
  aws_security_group_efs_submissions_access    = aws_security_group.efs_submissions_access
  aws_security_group_elasticache_sidekiq       = module.sidekiq.security_group_elasticache
  aws_security_group_elasticache_tooling_jobs  = module.tooling.security_group_elasticache_jobs
  aws_security_group_ssh                       = aws_security_group.ssh
  aws_security_group_rds_main                  = aws_security_group.rds_main
  aws_efs_file_system_repositories             = aws_efs_file_system.repositories
  aws_efs_file_system_submissions              = aws_efs_file_system.submissions
  aws_iam_policy_invoke_api_gateway_snippet_extractor     = module.snippet_extractor.iam_policy_invoke
  aws_iam_policy_invoke_api_gateway_lines_of_code_counter = module.lines_of_code_counter.iam_policy_invoke

  aws_vpc_main       = aws_vpc.main
  aws_subnet_publics = aws_subnet.publics
}

module "tooling_orchestrator" {
  source = "./tooling_orchestrator"

  region = var.region

  aws_account_id                               = data.aws_caller_identity.current.account_id
  aws_iam_policy_document_assume_role_ecs      = data.aws_iam_policy_document.assume_role_ecs
  aws_iam_policy_read_dynamodb_config          = aws_iam_policy.read_dynamodb_config
  aws_iam_policy_write_to_cloudwatch           = aws_iam_policy.write_to_cloudwatch
  aws_iam_policy_access_s3_bucket_tooling_jobs = module.files.bucket_tooling_jobs_access
  aws_iam_role_ecs_task_execution              = aws_iam_role.ecs_task_execution
  aws_security_group_elasticache_tooling_jobs  = module.tooling.security_group_elasticache_jobs

  aws_vpc_main       = aws_vpc.main
  aws_subnet_publics = aws_subnet.publics

  container_cpu    = 512
  container_memory = 1024
  container_count  = 1

  http_port = local.http_port
}

module "tooling_invoker" {
  source = "./tooling_invoker"

  region            = var.region
  ecr_tooling_repos = local.ecr_tooling_repos

  # aws_account_id                                         = data.aws_caller_identity.current.account_id
  # aws_iam_policy_read_dynamodb_config                         = aws_iam_policy.read_dynamodb_config
  # aws_iam_policy_write_to_cloudwatch                     = aws_iam_policy.write_to_cloudwatch
  # aws_iam_role_ecs_task_execution                        = aws_iam_role.ecs_task_execution
  aws_iam_policy_read_dynamodb_config_arn                  = aws_iam_policy.read_dynamodb_config.arn
  aws_iam_policy_read_dynamodb_tooling_language_groups_arn = aws_iam_policy.read_dynamodb_tooling_language_groups.arn
  aws_iam_policy_write_s3_bucket_tooling_jobs              = module.files.bucket_tooling_jobs_write
  aws_security_group_efs_repositories_access               = aws_security_group.efs_repositories_access
  aws_security_group_efs_submissions_access                = aws_security_group.efs_submissions_access

  aws_vpc_main       = aws_vpc.main
  aws_subnet_publics = aws_subnet.publics
}

module "github_deploy" {
  source = "./github_deploy"

  region = var.region

  aws_ecr_repo_arns = [
    module.snippet_extractor.ecr_repository_snippet_extractor.arn,
    module.lines_of_code_counter.ecr_repository_lines_of_code_counter.arn,

    module.tooling_orchestrator.ecr_repository_application.arn,
    module.tooling_orchestrator.ecr_repository_nginx.arn,

    module.webservers.ecr_repository_rails.arn,
    module.webservers.ecr_repository_nginx.arn,
    module.anycable.ecr_repository_go.arn
  ]
  aws_s3_bucket_name_assets = local.s3_bucket_assets_name
  aws_s3_bucket_name_icons  = local.s3_bucket_icons_name
}

module "tooling" {
  source = "./tooling"

  aws_vpc_main       = aws_vpc.main
  region             = var.region
  ecr_tooling_repos  = local.ecr_tooling_repos
  aws_subnet_publics = aws_subnet.publics
}

module "language_servers" {
  source = "./language_servers"

  region                    = var.region
  ecr_language_server_repos = local.ecr_language_server_repos

  aws_account_id                          = data.aws_caller_identity.current.account_id
  aws_iam_policy_document_assume_role_ecs = data.aws_iam_policy_document.assume_role_ecs
  aws_iam_policy_read_dynamodb_config     = aws_iam_policy.read_dynamodb_config
  aws_iam_policy_write_to_cloudwatch      = aws_iam_policy.write_to_cloudwatch
  aws_iam_role_ecs_task_execution         = aws_iam_role.ecs_task_execution

  aws_vpc_main       = aws_vpc.main
  aws_subnet_publics = aws_subnet.publics

  container_cpu    = 256
  container_memory = 512
  container_count  = 1

  http_port       = local.http_port
  websockets_port = local.websockets_port
}

module "git_server" {
  source = "./git_server"
}

module "snippet_extractor" {
  source = "./snippet_extractor"

  region         = var.region
  aws_account_id = data.aws_caller_identity.current.account_id
}

module "lines_of_code_counter" {
  source = "./lines_of_code_counter"

  region                                    = var.region
  aws_account_id                            = data.aws_caller_identity.current.account_id
  aws_subnet_publics                        = aws_subnet.publics
  aws_efs_mount_target_submissions          = aws_efs_mount_target.submissions
  aws_efs_file_system_submissions           = aws_efs_file_system.submissions
  aws_security_group_efs_submissions_access = aws_security_group.efs_submissions_access
}
