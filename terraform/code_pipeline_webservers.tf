#resource "aws_codepipeline" "webservers" {
#  name = "webservers-pipeline"
#  role_arn = aws_iam_role.webservers_codepipeline.arn

#  artifact_store {
#    location = aws_s3_bucket.webservers_codepipeline.bucket
#    type     = "S3"
#  }
#}
