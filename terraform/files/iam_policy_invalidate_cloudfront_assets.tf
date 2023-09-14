resource "aws_iam_policy" "invalidate_cloudfront_assets" {
  name        = "invalidate-cloudfront-assets"
  path        = "/"
  description = "Invalidate CloudWatch Assets"
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
    "Resource": "${aws_cloudfront_distribution.assets.arn}"
  }]
}
EOF
}

