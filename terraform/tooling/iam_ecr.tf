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
          ${join(",", formatlist("\"arn:aws:ecr:${var.region}:${local.aws_account_id}:repository/%s\"", var.ecr_tooling_repos))}
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

