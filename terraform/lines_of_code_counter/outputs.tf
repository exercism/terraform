output "ecr_repository" {
  value = aws_ecr_repository.lines_of_code_counter
}

output "lambda_function" {
  value = aws_lambda_function.main
}

