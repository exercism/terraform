resource "aws_cloudwatch_log_group" "tooling_jobs" {
  name              = "/tooling-jobs"
  retention_in_days = 3
}

resource "aws_cloudwatch_log_stream" "tooling_jobs_general" {
  name           = "general"
  log_group_name = aws_cloudwatch_log_group.tooling_jobs.name
}
