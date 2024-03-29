output "security_group_elasticache" {
  value = aws_security_group.elasticache
}

output "ecr_repository_go" {
  value = aws_ecr_repository.go
}

output "ecr_repository_go_pro" {
  value = aws_ecr_repository.go_pro
}

output "redis_url" {
  value = aws_elasticache_cluster.main.cache_nodes.0.address
}
