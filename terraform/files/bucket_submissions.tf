resource "aws_s3_bucket" "submissions" {
  bucket = var.bucket_submissions_name
}

resource "aws_s3_bucket_versioning" "submissions" {
  bucket = aws_s3_bucket.submissions.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "submissions" {
  bucket = aws_s3_bucket.submissions.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "submissions" {
  bucket = aws_s3_bucket.submissions.id

    rule {
      bucket_key_enabled = false

      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
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

