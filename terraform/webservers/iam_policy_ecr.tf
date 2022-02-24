resource "aws_iam_policy" "ecr" {
  name        = "webservers-ecr"
  description = "Read versions from ECR"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetRepositoryPolicy",
                "ecr:DescribeRepositories",
                "ecr:ListImages",
                "ecr:DescribeImages",
                "ecr:GetLifecyclePolicy",
                "ecr:GetLifecyclePolicyPreview",
                "ecr:ListTagsForResource"
            ],
            "Resource": [
              "arn:aws:ecr:${var.region}:${local.aws_account_id}:repository/*-test-runner",
              "arn:aws:ecr:${var.region}:${local.aws_account_id}:repository/*-representer",
              "arn:aws:ecr:${var.region}:${local.aws_account_id}:repository/*-analyzer"
            ]
        }, {
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


