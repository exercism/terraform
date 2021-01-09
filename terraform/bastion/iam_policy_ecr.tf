resource "aws_iam_policy" "ecr" {
  name        = "bastion-ecr"
  description = "Read from ECR"
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
              ${join(",", formatlist("\"arn:aws:ecr:${var.region}:${local.aws_account_id}:repository/%s\"", var.ecr_tooling_repos))}
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


