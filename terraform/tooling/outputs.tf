output "ecr_repository_url" {
  value = "${local.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com"
}
