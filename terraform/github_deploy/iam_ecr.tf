resource "aws_iam_user_policy" "ecr" {
  name = "github-deploy-ecr"
  user = local.username

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "GithubDeployECRReadWritePolicy",
        "Effect": "Allow",
        "Action": [
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "ecr:BatchCheckLayerAvailability",
            "ecr:PutImage",
            "ecr:InitiateLayerUpload",
            "ecr:UploadLayerPart",
            "ecr:CompleteLayerUpload"
        ],
        "Resource": [
          "arn:aws:ecr:${var.region}:${local.aws_account_id}:repository/${var.aws_ecr_repository_name_tooling_orchestrator_application}",
          "arn:aws:ecr:${var.region}:${local.aws_account_id}:repository/${var.aws_ecr_repository_name_tooling_orchestrator_nginx}",
          "arn:aws:ecr:${var.region}:${local.aws_account_id}:repository/${var.aws_ecr_repository_name_webserver_rails}",
          "arn:aws:ecr:${var.region}:${local.aws_account_id}:repository/${var.aws_ecr_repository_name_webserver_nginx}",
          "arn:aws:ecr:${var.region}:${local.aws_account_id}:repository/${var.aws_ecr_repository_name_webserver_anycable_go}"
        ]
    }, {
        "Sid": "GithubDeployECRAuthTokenPolicy",
        "Effect": "Allow",
        "Action": [
            "ecr:GetAuthorizationToken"
        ],
        "Resource": ["*"]
    }
  ]
}
EOF
}
