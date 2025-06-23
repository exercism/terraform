resource "aws_lambda_function" "main" {
  function_name = local.function_name
  role          = aws_iam_role.lambda.arn
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.lines_of_code_counter.repository_url}:production"

  file_system_config {
    arn              = var.aws_efs_access_point_tooling_jobs.arn
    local_mount_path = "/mnt/tooling_jobs"
  }

  vpc_config {
    subnet_ids         = var.aws_subnet_publics.*.id
    security_group_ids = [var.aws_security_group_efs_tooling_jobs_access.id]
  }

  depends_on = [var.aws_efs_mount_target_tooling_jobs]
}

