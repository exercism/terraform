resource "aws_iam_user_policy" "ecr" {
  name = "${local.username}-ecr"
  user = local.username

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
        "arn:aws:ecr:${var.region}:${local.aws_account_id}:repository/*-test-runner",
        "arn:aws:ecr:${var.region}:${local.aws_account_id}:repository/*-analyzer",
        "arn:aws:ecr:${var.region}:${local.aws_account_id}:repository/*-representer"
      ]
    }, {
      "Sid": "GithubDeployECRAuthTokenPolicy",
      "Effect": "Allow",
      "Action": [
          "ecr:GetAuthorizationToken"
      ],
      "Resource": ["*"]
    }  ]
}
EOF
}

