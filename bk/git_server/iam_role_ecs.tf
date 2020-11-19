resource "aws_iam_role" "ecs" {
  name               = "git-server-ecs"
  assume_role_policy = var.aws_iam_policy_document_assume_role_ecs.json
}
resource "aws_iam_role_policy_attachment" "write_to_cloudwatch" {
  role       = aws_iam_role.ecs.name
  policy_arn = var.aws_iam_policy_write_to_cloudwatch.arn
}
resource "aws_iam_role_policy_attachment" "read_dynamodb_config" {
  role       = aws_iam_role.ecs.name
  policy_arn = var.aws_iam_policy_read_dynamodb_config.arn
}

