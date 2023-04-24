resource "aws_iam_role" "lambda" {
  name = "chatgpt-proxy"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
POLICY
}
resource "aws_iam_role_policy_attachment" "read_secret_config" {
  role       = aws_iam_role.lambda.name
  policy_arn = var.aws_iam_policy_read_secret_config.arn
}
