resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${local.function_name}"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_group" "api_gateway_test" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.main.id}/test"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_group" "api_gateway_production" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.main.id}/production"
  retention_in_days = 1
}
