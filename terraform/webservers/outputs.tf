output "anycable_redis_url" {
  value = aws_elasticache_cluster.anycable.cache_nodes.0.address
}
output "sidekiq_redis_url" {
  value = aws_elasticache_cluster.sidekiq.cache_nodes.0.address
}
output "security_group_elasticache_sidekiq" {
  value = aws_security_group.elasticache_sidekiq
}
output "security_group_elasticache_anycable" {
  value = aws_security_group.elasticache_anycable
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
output "cloudfront_distribution_assets" {
  value = aws_cloudfront_distribution.assets
}

output "s3_bucket_icons" {
  value = aws_s3_bucket.icons
}
output "cloudfront_distribution_icons" {
  value = aws_cloudfront_distribution.icons
}

