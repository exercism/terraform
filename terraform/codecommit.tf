locals {
  username = "code-commit-replicator"
}

resource "aws_iam_user_policy" "write_to_codecommit" {
  name        = "write-to-codecommit"
  user = local.username
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": [
      "codecommit:GitPull",
      "codecommit:GitPush"
    ],
    "Resource": "*"
  }]
}
EOF
}

resource "aws_codecommit_repository" "repos" {
  for_each = local.github_repos
  repository_name     = each.key
}
