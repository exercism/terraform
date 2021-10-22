output "ecr_repository_lines_of_code_counter" {
  value = aws_ecr_repository.lines_of_code_counter
}

output "iam_policy_invoke" {
  value = aws_iam_policy.invoke
}

output "invoke_url" {
  value = aws_api_gateway_deployment.production.invoke_url
}
