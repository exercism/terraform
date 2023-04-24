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

  acm_certificate_arn = "arn:aws:acm:us-east-1:681735686245:certificate/a68be00b-70bc-48d1-84eb-5741fb1c0066"
  forum_acm_certificate_arn = "arn:aws:acm:us-east-1:681735686245:certificate/050200a9-85a7-4ddf-8854-a32748456352"

  efs_submissions_mount_point  = "/mnt/efs/submissions"
  efs_repositories_mount_point = "/mnt/efs/repos"

  s3_bucket_assets_name           = "exercism-v3-assets"
  s3_bucket_attachments_name      = "exercism-v3-attachments"
  s3_bucket_icons_name            = "exercism-v3-icons"
  s3_bucket_logs_name             = "exercism-v3-logs"
  s3_bucket_submissions_name      = "exercism-v3-submissions"
  s3_bucket_tooling_jobs_name     = "exercism-v3-tooling-jobs"
  s3_bucket_uploads_name          = "exercism-uploads"
  s3_bucket_tracks_dashboard_name = "tracks.exercism.io"

  ecr_tooling_repos = toset([
    "8th-test-runner",
    "abap-test-runner",
    "awk-test-runner",
    "ballerina-test-runner",
    "bash-analyzer",
    "bash-test-runner",
    "c-test-runner",
    "c-representer",
    "cfml-test-runner",
    "clojure-analyzer",
    "clojure-representer",
    "clojure-test-runner",
    "clojurescript-test-runner",
    "crystal-representer",
    "crystal-test-runner",
    "cobol-test-runner",
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
    "gleam-test-runner",
    "go-analyzer",
    "go-test-runner",
    "groovy-test-runner",
    "haskell-test-runner",
    "haxe-test-runner",
    "j-representer",
    "j-test-runner",
    "java-analyzer",
    "java-representer",
    "java-test-runner",
    "javascript-analyzer",
    "javascript-representer",
    "javascript-test-runner",
    "jq-test-runner",
    "julia-test-runner",
    "kotlin-test-runner",
    "lfe-test-runner",
    "lua-test-runner",
    "mips-test-runner",
    "nim-analyzer",
    "nim-test-runner",
    "ocaml-test-runner",
    "perl5-test-runner",
    "pharo-smalltalk-test-runner",
    "php-representer",
    "php-test-runner",
    "pony-test-runner",
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
    "unison-test-runner",
    "vbnet-test-runner",
    "vlang-test-runner",
    "vimscript-test-runner",
    "wasm-test-runner",
    "wren-representer",
    "wren-test-runner",
    "x86-64-assembly-test-runner",
    "zig-test-runner"
  ])


  ecr_lambda_repos = toset([
    "chatgpt-proxy",
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
  aws_security_group_es_general                = aws_security_group.es_general
  aws_efs_file_system_repositories             = aws_efs_file_system.repositories
  aws_efs_file_system_submissions              = aws_efs_file_system.submissions
  efs_submissions_mount_point                  = local.efs_submissions_mount_point
  efs_repositories_mount_point                 = local.efs_repositories_mount_point
  route53_zone_main                            = aws_route53_zone.main
  acm_certificate_arn                          = local.acm_certificate_arn
  aws_redis_url_anycable                       = module.anycable.redis_url
  aws_ecr_repository_anycable_go               = module.anycable.ecr_repository_go
  aws_ecr_repository_anycable_go_pro           = module.anycable.ecr_repository_go_pro

  aws_vpc_main       = aws_vpc.main
  aws_subnet_publics = aws_subnet.publics

  container_cpu    = 2048
  container_memory = 4096
  container_count  = 6

  service_website_cpu    = 1024
  service_website_memory = 2048
  service_website_count  = 6

  service_api_cpu    = 1024
  service_api_memory = 2048
  service_api_count  = 3

  service_anycable_cpu    = 2048
  service_anycable_memory = 4096
  service_anycable_count  = 6

  http_port       = local.http_port
  websockets_port = local.websockets_port
}

module "sidekiq" {
  source = "./sidekiq"

  region = var.region

  aws_ecr_repository_webserver_rails           = module.webservers.ecr_repository_rails
  aws_iam_policy_document_assume_role_ecs      = data.aws_iam_policy_document.assume_role_ecs
  aws_iam_policy_read_dynamodb_config          = aws_iam_policy.read_dynamodb_config
  aws_iam_policy_write_to_cloudwatch           = aws_iam_policy.write_to_cloudwatch
  aws_iam_policy_access_s3_bucket_submissions  = module.files.bucket_submissions_access
  aws_iam_policy_access_s3_bucket_tooling_jobs = module.files.bucket_tooling_jobs_access
  aws_iam_policy_access_s3_attachments         = module.files.bucket_attachments_access
  aws_iam_policy_access_s3_uploads             = module.files.bucket_uploads_access
  aws_iam_policy_read_secret_config            = aws_iam_policy.read_secret_config
  aws_iam_role_ecs_task_execution              = aws_iam_role.ecs_task_execution
  aws_security_group_elasticache_anycable      = module.anycable.security_group_elasticache
  aws_security_group_efs_repositories_access   = aws_security_group.efs_repositories_access
  aws_security_group_efs_submissions_access    = aws_security_group.efs_submissions_access
  aws_security_group_rds_main                  = aws_security_group.rds_main
  aws_security_group_elasticache_tooling_jobs  = module.tooling.security_group_elasticache_jobs
  aws_security_group_es_general                = aws_security_group.es_general
  aws_efs_file_system_repositories             = aws_efs_file_system.repositories
  aws_efs_file_system_submissions              = aws_efs_file_system.submissions
  efs_submissions_mount_point                  = local.efs_submissions_mount_point
  efs_repositories_mount_point                 = local.efs_repositories_mount_point

  aws_vpc_main       = aws_vpc.main
  aws_subnet_publics = aws_subnet.publics

  container_cpu    = 1024
  container_memory = 2048
  container_count  = 2
  monitor_port     = 3333
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
  aws_security_group_es_general                = aws_security_group.es_general
  aws_efs_file_system_repositories             = aws_efs_file_system.repositories
  aws_efs_file_system_submissions              = aws_efs_file_system.submissions

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

  region                              = var.region
  aws_iam_policy_read_dynamodb_config = aws_iam_policy.read_dynamodb_config
  aws_iam_policy_read_secret_config   = aws_iam_policy.read_secret_config

  aws_ecr_repo_arns = [
    module.sidekiq.ecr_repository_monitor.arn,
    module.chatgpt_proxy.ecr_repository_chatgpt_proxy.arn,
    module.snippet_extractor.ecr_repository_snippet_extractor.arn,
    module.lines_of_code_counter.ecr_repository_lines_of_code_counter.arn,

    module.tooling_orchestrator.ecr_repository_application.arn,
    module.tooling_orchestrator.ecr_repository_nginx.arn,

    module.webservers.ecr_repository_rails.arn,
    module.webservers.ecr_repository_nginx.arn,
    module.anycable.ecr_repository_go.arn

  ]
  aws_s3_bucket_name_assets           = local.s3_bucket_assets_name
  aws_s3_bucket_name_icons            = local.s3_bucket_icons_name
  aws_s3_bucket_name_tracks_dashboard = local.s3_bucket_tracks_dashboard_name

  cloudfront_distribution_icons = module.files.cloudfront_distribution_icons
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

module "chatgpt_proxy" {
  source = "./chatgpt_proxy"

  region                    = var.region
  aws_account_id            = data.aws_caller_identity.current.account_id
  aws_alb_listener_internal = aws_alb_listener.internal
  aws_iam_policy_read_secret_config            = aws_iam_policy.read_secret_config
}

module "snippet_extractor" {
  source = "./snippet_extractor"

  region                    = var.region
  aws_account_id            = data.aws_caller_identity.current.account_id
  aws_alb_listener_internal = aws_alb_listener.internal
}

module "lines_of_code_counter" {
  source = "./lines_of_code_counter"

  region                                    = var.region
  aws_account_id                            = data.aws_caller_identity.current.account_id
  aws_subnet_publics                        = aws_subnet.publics
  aws_efs_mount_target_submissions          = aws_efs_mount_target.submissions
  aws_efs_access_point_submissions          = aws_efs_access_point.submissions
  aws_security_group_efs_submissions_access = aws_security_group.efs_submissions_access
  aws_alb_listener_internal                 = aws_alb_listener.internal
}

module "discourse" {
  source = "./discourse"

  region = var.region
  aws_vpc_main       = aws_vpc.main
  aws_subnet_publics = aws_subnet.publics
  acm_certificate_arn = local.forum_acm_certificate_arn
}


