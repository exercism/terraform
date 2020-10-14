output "ecr_repository_name_application" {
  value = aws_ecr_repository.application.name
}

output "ecr_repository_name_nginx" {
  value = aws_ecr_repository.nginx.name
}

output "alb_hostname" {
  value = aws_alb.tooling_orchestrators.dns_name
}

