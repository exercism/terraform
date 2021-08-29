output "ecr_repository_snippet_extractor" {
  value = aws_ecr_repository.snippet_extractor
}

output "iam_policy_invoke" {
  value = aws_iam_policy.invoke
}
