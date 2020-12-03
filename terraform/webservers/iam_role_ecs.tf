resource "aws_iam_role" "ecs" {
  name               = "webserver-ecs"
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
resource "aws_iam_role_policy_attachment" "access_dynamodb_tooling_jobs" {
  role       = aws_iam_role.ecs.name
  policy_arn = var.aws_iam_policy_access_dynamodb_tooling_jobs.arn
}
resource "aws_iam_role_policy_attachment" "access_s3_bucket_submissions" {
  role       = aws_iam_role.ecs.name
  policy_arn = var.aws_iam_policy_access_s3_bucket_submissions.arn
}
resource "aws_iam_role_policy_attachment" "access_s3_bucket_tooling_jobs" {
  role       = aws_iam_role.ecs.name
  policy_arn = var.aws_iam_policy_access_s3_bucket_tooling_jobs.arn
}
resource "aws_iam_role_policy_attachment" "read_secret_config" {
  role       = aws_iam_role.ecs.name
  policy_arn = var.aws_iam_policy_read_secret_config.arn
}
