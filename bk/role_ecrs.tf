resource "aws_iam_role" "ecr_pusher" {
  name = "tooling-ecr-pusher"
  
  assume_role_policy = <<-EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": [
          "arn:aws:iam::${local.aws_account_id}:user/${local.username}"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ecrs" {
  for_each = var.ecr_tooling_repos
  name     = "tooling-ecr-pusher-${each.key}"
  role    = aws_iam_role.ecr_pusher.id

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
          "arn:aws:ecr:${var.region}:${local.aws_account_id}:repository/${each.key}"
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













resource "aws_iam_role" "ecr_pushers" {
  for_each = var.ecr_tooling_repos
  name     = "tooling-ecr-pusher-${each.key}"

  assume_role_policy = <<-EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": [
          "arn:aws:iam::${local.aws_account_id}:user/${local.username}"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ecr_pushers" {
  for_each = var.ecr_tooling_repos
  name     = "tooling-ecr-pusher-${each.key}"
  role     = aws_iam_role.ecr_pushers[each.key].id

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
          "arn:aws:ecr:${var.region}:${local.aws_account_id}:repository/${each.key}"
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

