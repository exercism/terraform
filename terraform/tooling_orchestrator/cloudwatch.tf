resource "aws_cloudwatch_log_group" "tooling_orchestrators" {
  name = "tooling-orchestrators"

  retention_in_days = 1
}

