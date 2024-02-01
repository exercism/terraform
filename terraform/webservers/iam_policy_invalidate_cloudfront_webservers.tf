resource "aws_iam_policy" "invalidate_cloudfront_webservers" {
  name        = "invalidate-cloudfront-webservers"
  path        = "/"
  description = "Invalidate CloudWatch Webservers"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": [
      "cloudfront:CreateInvalidation",
      "cloudfront:GetInvalidation",
      "cloudfront:ListInvalidations"
    ],
    "Resource": "${aws_cloudfront_distribution.webservers.arn}"
  }]
}
EOF
}


