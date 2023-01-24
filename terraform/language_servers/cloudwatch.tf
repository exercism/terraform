resource "aws_cloudwatch_log_group" "language_servers" {
  name = "language-servers"

  retention_in_days = 1
}

