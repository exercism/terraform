output "ecr_repository_url" {
  value = "${local.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com"
}

output "security_group_elasticache_jobs" {
  value = aws_security_group.elasticache_jobs
}

output "redis_url" {
  value = aws_elasticache_cluster.jobs.cache_nodes.0.address
}
