output "ecr_repository_url" {
  value = "${local.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com"
}

output "security_group_elasticache_jobs" {
  value = aws_security_group.elasticache_jobs
}

output "redis_url" {
  value = aws_elasticache_serverless_cache.tooling_jobs.endpoint[0].address
}

output "aws_cloudwatch_jobs_log_group" {
  value = aws_cloudwatch_log_group.tooling_jobs
}

output "aws_cloudwatch_log_stream_jobs_general" {
  value = aws_cloudwatch_log_stream.tooling_jobs_general
}
