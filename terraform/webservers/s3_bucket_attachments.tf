/* TODO: Move to top level namespace */
resource "aws_s3_bucket" "attachments" {
  # TODO - Change this to the real bucket
  bucket = var.s3_attachments_bucket_name

  # TODO: Change this to private when going via cloudfront
  acl = "public-read"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["HEAD", "GET"]
    allowed_origins = ["${var.website_protocol}://${var.website_host}"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
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

