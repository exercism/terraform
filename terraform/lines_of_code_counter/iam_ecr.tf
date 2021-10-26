resource "aws_iam_user_policy" "ecr" {
  name = "lines-of-code-counter-ecr"
  user = local.username

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
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
      "Resource": "${aws_ecr_repository.lines_of_code_counter.arn}"
    }, {
      "Sid": "GithubDeployECRAuthTokenPolicy",
      "Effect": "Allow",
      "Action": [
          "ecr:GetAuthorizationToken"
      ],
      "Resource": ["*"]
    }, {
      "Effect": "Allow",
      "Action": [
        "iam:ListRoles",
        "lambda:UpdateFunctionCode",
        "lambda:CreateFunction",
        "lambda:UpdateFunctionConfiguration"
      ],
      "Resource": "${aws_lambda_function.main.arn}"
    }
  ]
}
EOF
}
