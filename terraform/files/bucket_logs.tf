resource "aws_s3_bucket" "ops_bucket" {
  bucket = var.bucket_logs_name
  acl    = "private"
}
