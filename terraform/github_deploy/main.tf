variable "region" {}

# TODO: It would be nice if this was just an array of 
# repository names and the template used an each block
# so that we don't leak all this info into this module
variable "aws_ecr_repository_name_tooling_orchestrator_application" {}
variable "aws_ecr_repository_name_tooling_orchestrator_nginx" {}
variable "aws_ecr_repository_name_webserver_rails" {}
variable "aws_ecr_repository_name_webserver_nginx" {}
variable "aws_ecr_repository_name_webserver_anycable_go" {}
variable "aws_s3_bucket_name_webservers_assets" {}

data "aws_caller_identity" "current" {}

locals {
  aws_account_id = data.aws_caller_identity.current.account_id
  username       = "github-deploy"
}
