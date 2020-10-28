output "ecr_repository_arn_application" {
  value = aws_ecr_repository.application.arn
}

output "ecr_repository_arn_nginx" {
  value = aws_ecr_repository.nginx.arn
}

output "alb_hostname" {
  value = aws_alb.git_server.dns_name
}
