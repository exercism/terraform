variable "aws_vpc_main" {}
variable "region" {}
variable "ecr_tooling_repos" {}
variable "aws_subnet_publics" {}

data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

locals {
  aws_account_id = data.aws_caller_identity.current.account_id
  username       = "tooling-public-write-user"
}
