resource "aws_iam_user_policy" "read_roles" {
  name = "${local.username}-read-roles"
  user = local.username

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "iam:ListRoles"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_user_policy" "assume_roles" {
  name = "${local.username}-assume-role"
  user = local.username

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["sts:AssumeRole"],
      "Resource": "arn:aws:iam::${local.aws_account_id}:role/tooling-ecr-pusher-*"
    }
  ]
}
EOF
}


