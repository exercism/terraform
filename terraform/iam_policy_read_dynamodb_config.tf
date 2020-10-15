resource "aws_iam_policy" "read_dynamodb_config" {
  name        = "read-dynamodb_config"
  description = "Read DynamoDB Config"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": [
        "dynamodb:DescribeTable",
        "dynamodb:Query",
        "dynamodb:Scan"
    ],
    "Resource": "${aws_dynamodb_table.config.arn}"
  }]
}
EOF
}


