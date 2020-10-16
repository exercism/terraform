resource "aws_iam_policy" "access_s3_bucket_tooling_jobs" {
  name        = "access-s3-bucket-tooling-jobs"
  path        = "/"
  description = "Assess the tooling_jobs s3 bucket"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": ["${aws_s3_bucket.tooling_jobs.arn}"]
    }, 
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:GetObject"
      ],
      "Resource": ["${aws_s3_bucket.tooling_jobs.arn}/*"]
    }
  ]
}
EOF
}

