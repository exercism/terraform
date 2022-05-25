output "security_group_ecs" {
  value = aws_security_group.ecs
}

output "security_group_elasticache" {
  value = aws_security_group.elasticache
}

output "ecr_repository_monitor" {
  value = aws_ecr_repository.sidekiq_monitor
}

output "redis_url" {
  value = aws_elasticache_cluster.main.cache_nodes.0.address
}
