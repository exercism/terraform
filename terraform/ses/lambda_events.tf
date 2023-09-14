resource "aws_lambda_function" "events" {
  function_name    = local.events_function_name
  role             = aws_iam_role.events_lambda.arn
  package_type     = "Zip"
  filename         = data.archive_file.events_lambda.output_path
  source_code_hash = data.archive_file.events_lambda.output_base64sha256
  runtime          = "nodejs18.x"
  handler          = "index.handler"
  publish          = true
  memory_size      = 256
  timeout          = 5

  vpc_config {
    subnet_ids         = [var.aws_subnet_lambda.id]
    security_group_ids = [aws_security_group.events_lambda.id]
  }
}

resource "aws_lambda_permission" "events_from_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.events.arn
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.events.arn
}

data "archive_file" "events_lambda" {
  type        = "zip"
  source_file = "ses/lambda_functions/bounce_handler/index.js"
  output_path = "ses/lambda_functions/bounce_handler/function.zip"
}

