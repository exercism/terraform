resource "aws_s3_bucket" "icons" {
  bucket = var.bucket_icons_name
  acl    = "private"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["HEAD", "GET"]
    allowed_origins = ["${var.website_protocol}://${var.website_host}"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

data "aws_iam_policy_document" "bucket_icons_read" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.icons.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.icons.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_icons_read" {
  bucket = aws_s3_bucket.icons.id
  policy = data.aws_iam_policy_document.bucket_icons_read.json
}

