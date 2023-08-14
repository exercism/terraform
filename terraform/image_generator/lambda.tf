resource "aws_lambda_function" "main" {
  function_name = local.function_name
  role          = aws_iam_role.lambda.arn
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.image_generator.repository_url}:production"
  memory_size = 256
  timeout = 20

  vpc_config {
    subnet_ids         = var.aws_subnet_publics.*.id
    security_group_ids = [aws_security_group.main.id]
  }
}
resource "aws_lambda_function_url" "main" {
  function_name      = aws_lambda_function.main.function_name
  authorization_type = "NONE"
}
