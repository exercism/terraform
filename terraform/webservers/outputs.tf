output "anycable_redis_url" {
  value = aws_elasticache_cluster.anycable.cache_nodes.0.address
}

output "alb_hostname" {
  value = aws_alb.webservers.dns_name
}

output "ecr_repository_rails" {
  value = aws_ecr_repository.rails
}

output "ecr_repository_nginx" {
  value = aws_ecr_repository.nginx
}

output "ecr_repository_anycable_go" {
  value = aws_ecr_repository.anycable_go
}

output "s3_bucket_assets" {
  value = aws_s3_bucket.assets
}
