resource "aws_iam_user_policy" "ecr" {
  name = "ecr"
  user = "lambda-public-write-user"

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
      "Resource": [
        "${module.chatgpt_proxy.ecr_repository.arn}",
        "${module.image_generator.ecr_repository.arn}",
        "${module.lines_of_code_counter.ecr_repository.arn}",
        "${module.snippet_extractor.ecr_repository.arn}"
      ]
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
        "lambda:UpdateFunctionConfiguration",
        "lambda:GetFunction",
        "lambda:GetFunctionConfiguration"
      ],
      "Resource": [
        "${module.chatgpt_proxy.lambda_function.arn}",
        "${module.image_generator.lambda_function.arn}",
        "${module.lines_of_code_counter.lambda_function.arn}",
        "${module.snippet_extractor.lambda_function.arn}"
      ]
    }
  ]
}
EOF
}

