
output "security_group_ecs" {
  value = aws_security_group.ecs
}

output "security_group_cache" {
  value = aws_security_group.elasticache_cache
}

output "cache_hostname" {
  value = aws_elasticache_serverless_cache.cache.endpoint[0].address
}

output "alb_hostname" {
  value = aws_alb.webservers.dns_name
}

output "cloudfront_distribution_webservers" {
  value = aws_cloudfront_distribution.webservers
}

output "ecr_repository_rails" {
  value = aws_ecr_repository.rails
}

output "ecr_repository_nginx" {
  value = aws_ecr_repository.nginx
}

output "iam_policy_invalidate_cloudfront_webservers" {
  value = aws_iam_policy.invalidate_cloudfront_webservers
}
