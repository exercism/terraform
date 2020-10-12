variable "region" {
  default = "eu-west-2"
}

provider "aws" {
  region  = var.region
  version = "~> 2.64"
}

# Fetch AZs in the current region
data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

module "webservers" {
  source = "./webservers"

  region = var.region

  aws_iam_policy_document_assume_ecs_role                = data.aws_iam_policy_document.assume_ecs_role
  aws_iam_policy_access_dynamodb                         = aws_iam_policy.access_dynamodb
  aws_iam_policy_write_to_cloudwatch                     = aws_iam_policy.write_to_cloudwatch
  aws_iam_role_ecs_task_execution                        = aws_iam_role.ecs_task_execution
  aws_iam_role_policy_attachment_ecs_task_execution_role = aws_iam_role_policy_attachment.ecs_task_execution_role

  aws_vpc_main       = aws_vpc.main
  aws_subnet_publics = aws_subnet.publics

  container_cpu    = 256
  container_memory = 512
  container_count  = 1

  http_port       = 80
  websockets_port = 3334
}

module "tooling_orchestrator" {
  source = "./tooling_orchestrator"

  region = var.region

  aws_account_id                                         = data.aws_caller_identity.current.account_id
  aws_iam_policy_document_assume_ecs_role                = data.aws_iam_policy_document.assume_ecs_role
  aws_iam_policy_access_dynamodb                         = aws_iam_policy.access_dynamodb
  aws_iam_policy_write_to_cloudwatch                     = aws_iam_policy.write_to_cloudwatch
  aws_iam_role_ecs_task_execution                        = aws_iam_role.ecs_task_execution
  aws_iam_role_policy_attachment_ecs_task_execution_role = aws_iam_role_policy_attachment.ecs_task_execution_role

  aws_vpc_main       = aws_vpc.main
  aws_subnet_publics = aws_subnet.publics

  container_cpu    = 256
  container_memory = 512
  container_count  = 1

  http_port = 80
}

module "github_deploy" {
  source = "./github_deploy"

  region = var.region

  aws_ecr_repository_name_tooling_orchestrator_application = module.tooling_orchestrator.ecr_repository_name_application
  aws_ecr_repository_name_tooling_orchestrator_nginx       = module.tooling_orchestrator.ecr_repository_name_nginx
  aws_ecr_repository_name_webserver_rails                  = module.webservers.ecr_repository_name_rails
  aws_ecr_repository_name_webserver_nginx                  = module.webservers.ecr_repository_name_nginx
  aws_ecr_repository_name_webserver_anycable_go            = module.webservers.ecr_repository_name_anycable_go
}
