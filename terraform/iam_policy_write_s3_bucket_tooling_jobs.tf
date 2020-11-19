resource "aws_iam_policy" "write_s3_bucket_tooling_jobs" {
  name        = "write-s3-bucket-tooling-jobs"
  path        = "/"
  description = "Write to the tooling_jobs s3 bucket"
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
        "s3:PutObjectAcl"
      ],
      "Resource": ["${aws_s3_bucket.tooling_jobs.arn}/*"]
    }
  ]
}
EOF
}

