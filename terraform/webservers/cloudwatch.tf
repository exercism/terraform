resource "aws_cloudwatch_log_group" "webservers" {
  name = "webservers"

  retention_in_days = 1
}

resource "aws_cloudwatch_log_group" "puma" {
  name = "webservers/puma"

  retention_in_days = 3
}

resource "aws_cloudwatch_log_group" "nginx" {
  name = "webservers/nginx"

  retention_in_days = 1
}

resource "aws_cloudwatch_log_group" "anycable" {
  name = "webservers/anycable"

  retention_in_days = 1
}
