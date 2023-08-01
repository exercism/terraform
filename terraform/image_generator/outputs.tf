output "ecr_repository" {
  value = aws_ecr_repository.image_generator
}

output "lambda_function" {
  value = aws_lambda_function.main
}
