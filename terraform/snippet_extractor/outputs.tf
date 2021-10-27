output "ecr_repository_snippet_extractor" {
  value = aws_ecr_repository.snippet_extractor
}

output "invoke_url" {
  value = aws_api_gateway_deployment.production.invoke_url
}
