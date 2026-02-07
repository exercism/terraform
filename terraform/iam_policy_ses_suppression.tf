resource "aws_iam_policy" "ses_suppression" {
  name        = "ses-suppression"
  path        = "/"
  description = "Manage SES suppression list"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": [
        "ses:PutSuppressedDestination"
    ],
    "Resource": "*"
  }]
}
EOF
}
