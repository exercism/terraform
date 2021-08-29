resource "aws_iam_policy" "invoke" {
  name        = "snippet-extractor-invoke"
  description = "Execute snippet extractor API"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "execute-api:Invoke"
      ],
      "Resource": [
        "${aws_api_gateway_resource.main.arn}"
      ]
    }
  ]
}
EOF
}

