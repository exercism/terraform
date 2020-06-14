resource "aws_s3_bucket" "webservers_codepipeline" {
  bucket = "exercism-webservers-codepipeline"
  acl    = "private"
}

