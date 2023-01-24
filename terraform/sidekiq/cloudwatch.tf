resource "aws_cloudwatch_log_group" "sidekiq" {
  name = "sidekiq"

  retention_in_days = 1
}
