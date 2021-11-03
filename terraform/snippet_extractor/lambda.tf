resource "aws_lambda_function" "main" {
  function_name = local.function_name
  role          = aws_iam_role.lambda.arn
  package_type = "Image"
  image_uri     = "${aws_ecr_repository.snippet_extractor.repository_url}:production"
}

