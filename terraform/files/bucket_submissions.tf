resource "aws_s3_bucket" "submissions" {
  bucket = var.bucket_submissions_name
  acl    = "private"

  versioning {
    enabled = true
  }
}

# Note: This policy does not have the ability to delete objects
resource "aws_iam_policy" "bucket_submissions_access" {
  name        = "s3-bucket-submissions-access"
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
        "s3:GetObject"
      ],
      "Resource": ["${aws_s3_bucket.submissions.arn}/*"]
    }
  ]
}
EOF
}

