output "ecr_repository_application" {
  value = aws_ecr_repository.application
}

output "ecr_repository_nginx" {
  value = aws_ecr_repository.nginx
}

output "alb_hostname" {
  value = aws_alb.tooling_orchestrators.dns_name
}

output "security_group_ecs" {
  value = aws_security_group.ecs
}
