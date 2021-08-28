
output "security_group_ecs" {
  value = aws_security_group.ecs
}

output "alb_hostname" {
  value = aws_alb.webservers.dns_name
}
output "cloudfront_distribution_webservers_hostname" {
  value = aws_cloudfront_distribution.webservers.domain_name
}

output "ecr_repository_rails" {
  value = aws_ecr_repository.rails
}

output "ecr_repository_nginx" {
  value = aws_ecr_repository.nginx
}

