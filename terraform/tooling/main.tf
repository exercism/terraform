variable "region" {}
variable "ecr_tooling_repos" {}

data "aws_caller_identity" "current" {}

locals {
  aws_account_id = data.aws_caller_identity.current.account_id
  username       = "tooling-public-write-user"
}
