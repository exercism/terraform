resource "aws_iam_user_policy" "ecr" {
  name = "${local.public_username}-ecr"
  user = local.public_username

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "ToolingECRReadWritePolicy",
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
          "arn:aws:ecr:${var.region}:${local.aws_account_id}:repository/${aws_ecr_repository.ruby_test_runner.name}"
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

