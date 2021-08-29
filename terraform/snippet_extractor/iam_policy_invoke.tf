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
        "${aws_api_gateway_deployment.production.execution_arn}/${aws_api_gateway_method.post.http_method}/${aws_api_gateway_resource.main.path_part}"
      ]
    }
  ]
}
EOF
}

