resource "aws_s3_bucket" "tooling_jobs" {
  # TODO - Change this to the real bucket
  bucket = "exercism-tooling-jobs-staging"
  acl    = "private"
}

