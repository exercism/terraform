resource "aws_s3_bucket" "assets" {
  # TODO - Change this to the real bucket
  bucket = "exercism-assets-staging" 
  acl    = "public-read"
}
