resource "aws_iam_policy" "read_dynamodb_tooling_language_groups" {
  name        = "read-dynamodb_tooling_language_groups"
  description = "Read DynamoDB tooling_language_groups"
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
    "Resource": "${aws_dynamodb_table.tooling_language_groups.arn}"
  }]
}
EOF
}



