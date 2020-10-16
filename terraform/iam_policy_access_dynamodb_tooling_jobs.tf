# Note: This policy does not have the ability to delete items ("dynamodb:DeleteItem",)
#
resource "aws_iam_policy" "access_dynamodb_tooling_jobs" {
  name        = "access-dynamodb-tooling-jobs"
  path        = "/"
  description = "Access DynamoDB tooling_jobs Table"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": [
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:GetItem",
      "dynamodb:BatchGetItem",
      "dynamodb:Scan",
      "dynamodb:Query",
      "dynamodb:ConditionCheckItem"
    ],
    "Resource": [
      "${aws_dynamodb_table.tooling_jobs.arn}",
      "${aws_dynamodb_table.tooling_jobs.arn}/index/*"
    ]
  }]
}
EOF
}


