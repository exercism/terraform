resource "aws_s3_bucket" "tooling_jobs" {
  bucket = var.bucket_tooling_jobs_name
  acl    = "private"
}

resource "aws_iam_policy" "bucket_tooling_jobs_write" {
  name        = "s3-bucket-tooling-jobs-write"
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

# Note: This policy does not have the ability to delete objects
resource "aws_iam_policy" "bucket_tooling_jobs_access" {
  name        = "s3-bucket-tooling-jobs-access"
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
