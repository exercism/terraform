resource "aws_s3_bucket" "ops_bucket" {
  # TODO - Change this to the real bucket
  bucket = "exercism-ops-staging" 
  acl    = "private"
}
