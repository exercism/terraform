resource "aws_iam_policy" "cloudwatch_logs" {
  name        = "tooling-invoker-cloudwatch-logs"
  description = "Write to cloudwatch logs"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      "Resource": "${var.aws_cloudwatch_log_stream_jobs_general.arn}",
      "Effect": "Allow"
    }
  ]
}
EOF
}


