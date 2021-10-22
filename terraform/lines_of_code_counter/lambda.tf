resource "aws_lambda_function" "main" {
  function_name = local.function_name
  role          = aws_iam_role.lambda.arn
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.lines_of_code_counter.repository_url}:production"

  file_system_config {
    arn              = aws_efs_access_point.submissions.arn
    local_mount_path = "/mnt/submissions"
  }

  vpc_config {
    subnet_ids         = var.aws_subnet_publics.*.id
    security_group_ids = [var.aws_security_group_efs_submissions_access.id]
  }

  depends_on = [var.aws_efs_mount_target_submissions]
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.main.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "${aws_api_gateway_rest_api.main.execution_arn}/*/*/*"
}

# EFS access point used by lambda file system
resource "aws_efs_access_point" "submissions" {
  file_system_id = var.aws_efs_file_system_submissions.id

  root_directory {
    path = "/mnt/submissions"
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = "555"
    }
  }

  posix_user {
    gid = 1000
    uid = 1000
  }
}
