resource "aws_lambda_function" "main" {
  function_name = local.function_name
  role          = aws_iam_role.lambda.arn
  package_type = "Image"
  image_uri     = "${aws_ecr_repository.chatgpt_proxy.repository_url}:production"
  timeout = "20"
}

