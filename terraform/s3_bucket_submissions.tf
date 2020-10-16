resource "aws_s3_bucket" "submissions" {
  # TODO - Change this to the real bucket
  bucket = "exercism-submissions-staging"
  acl    = "private"
}
