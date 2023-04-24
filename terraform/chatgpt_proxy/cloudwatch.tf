resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/lambda/${local.function_name}"
  retention_in_days = 1
}

