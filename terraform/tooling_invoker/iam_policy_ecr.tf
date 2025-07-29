resource "aws_iam_policy" "ecr" {
  name        = "tooling-invoker-ecr"
  description = "Read from ECR"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetRepositoryPolicy",
        "ecr:DescribeRepositories",
        "ecr:ListImages",
        "ecr:DescribeImages",
        "ecr:BatchGetImage",
        "ecr:GetLifecyclePolicy",
        "ecr:GetLifecyclePolicyPreview",
        "ecr:ListTagsForResource",
        "ecr:DescribeImageScanFindings"
      ],
      "Resource": [
        "arn:aws:ecr:${var.region}:${local.aws_account_id}:repository/*-test-runner",
        "arn:aws:ecr:${var.region}:${local.aws_account_id}:repository/*-test-runner-arm64",
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
