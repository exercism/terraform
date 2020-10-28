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
          ${join(",", formatlist("\"%s\"", var.aws_ecr_repo_arns))}
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
