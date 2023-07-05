resource "aws_s3_bucket" "attachments" {
  bucket = var.bucket_attachments_name

  versioning {
    enabled = true
  }

  # TODO: Change this to private when going via cloudfront
  acl = "public-read"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["HEAD", "GET"]
    allowed_origins = ["${var.website_protocol}://${var.website_host}"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

  server_side_encryption_configuration {
    rule {
      bucket_key_enabled = false

      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

}

resource "aws_iam_policy" "bucket_attachments_access" {
  name = "s3-bucket-attachments-access"
  path        = "/"
  description = "Access s3 attachments"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": ["s3:ListBucket"],
        "Resource": ["${aws_s3_bucket.attachments.arn}"]
      }, {
        "Effect": "Allow",
        "Action": [
          "s3:GetObject",
          "s3:PutObject",
          "s3:PutObjectAcl"
        ],
        "Resource": ["${aws_s3_bucket.attachments.arn}/*"]
      }
    ]
}
EOF
}




  # TODO: Add for cloudfront
# data "aws_iam_policy_document" "s3_attachments" {
#   statement {
#     actions   = ["s3:GetObject"]
#     resources = ["${aws_s3_bucket.attachments.arn}/*"]

#     principals {
#       type        = "AWS"
#       identifiers = [aws_cloudfront_origin_access_identity.attachments.iam_arn]
#     }
#   }
# }

# resource "aws_s3_bucket_policy" "attachments" {
#   bucket = aws_s3_bucket.attachments.id
#   policy = data.aws_iam_policy_document.s3_attachments.json
# }

