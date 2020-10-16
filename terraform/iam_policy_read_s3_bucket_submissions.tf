resource "aws_iam_policy" "read_s3_bucket_submissions" {
  name        = "read-s3-bucket-submissions"
  path        = "/"
  description = "Access the submissions s3 bucket"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": ["${aws_s3_bucket.submissions.arn}"]
    }, 
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Resource": ["${aws_s3_bucket.submissions.arn}/*"]
    }
  ]
}
EOF
}

