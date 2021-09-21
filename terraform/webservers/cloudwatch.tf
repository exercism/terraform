resource "aws_cloudwatch_log_group" "webservers" {
  name = "webservers"

  retention_in_days = 3
}
