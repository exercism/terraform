output "ecr_repository" {
  value = aws_ecr_repository.chatgpt_proxy
}

output "lambda_function" {
  value = aws_lambda_function.main
}

