#module "webservers" {
#  source = "./webservers"
#}
variable "region" {}

provider "aws" {
  region  = var.region
  profile = "exercism_terraform"
  version = "~> 2.64"
}

# Fetch AZs in the current region
data "aws_availability_zones" "available" {}

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

# module "tooling_orchestrator" {
#   source = "./tooling_orchestrator"

#   region = var.region
#   aws_iam_policy_document_assume_ecs_role = data.aws_iam_policy_document.assume_ecs_role
#   aws_iam_policy_access_dynamodb = aws_iam_policy.access_dynamodb
#   aws_iam_policy_write_to_cloudwatch = aws_iam_policy.write_to_cloudwatch
# }


