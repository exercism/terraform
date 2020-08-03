resource "aws_iam_policy" "write_to_cloudwatch" {
  name        = "write_to_cloudwatch"
  path        = "/"
  description = "Write to CloudWatch"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents"
    ],
    "Resource": "*"
  }]
}
EOF
}
