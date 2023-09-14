resource "aws_lambda_function" "main" {
  function_name = local.function_name
  role          = aws_iam_role.lambda.arn
  package_type = "Image"
  image_uri     = "${aws_ecr_repository.chatgpt_proxy.repository_url}:production"
  timeout = "30"

  vpc_config {
    subnet_ids         = [var.aws_subnet_lambda.id]
    security_group_ids = [aws_security_group.main.id]
  }
}
