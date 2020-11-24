resource "aws_s3_bucket" "assets" {
  # TODO - Change this to the real bucket
  bucket = "exercism-assets-staging"
  acl    = "public-read"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["HEAD", "GET"]
    allowed_origins = ["${var.website_protocol}://${var.website_host}"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}
