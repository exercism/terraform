# This is an old legacy bucket that stores
# files from v3. Is it managed by terraform but
# was not created by it and is in a weird zone.
resource "aws_s3_bucket" "uploads" {
  provider = aws.eu_west_1
  bucket = var.bucket_uploads_name

  versioning {
    enabled = true
  }

  # TODO: Change this to private when going via cloudfront
  acl = "private"

  # TODO: Add this back in
  # cors_rule {
  #   allowed_headers = ["*"]
  #   allowed_methods = ["HEAD", "GET"]
  #   allowed_origins = ["${var.website_protocol}://${var.website_host}"]
  #   expose_headers  = ["ETag"]
  #   max_age_seconds = 3000
  # }
}

resource "aws_iam_policy" "bucket_uploads_access" {
  name = "s3-bucket-uploads-access"
  path        = "/"
  description = "Access s3 uploads"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": ["s3:ListBucket"],
        "Resource": ["${aws_s3_bucket.uploads.arn}"]
      }, {
        "Effect": "Allow",
        "Action": [
          "s3:GetObject",
          "s3:PutObject",
          "s3:PutObjectAcl"
        ],
        "Resource": ["${aws_s3_bucket.uploads.arn}/*"]
      }
    ]
}
EOF
}


provider "aws" {
  region = "eu-west-1"
  alias  = "eu_west_1"
}

