resource "aws_iam_user_policy" "s3" {
  name = "github-deploy-s3"
  user = local.username

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "GithubDeployS3ReadWritePolicy",
        "Effect": "Allow",
        "Action": [
          "s3:PutObject",
          "s3:GetObject"
        ],
        "Resource": [
          "arn:aws:s3:::/${var.aws_s3_bucket_name_webservers_assets}"
        ]
      }
    ]
}
EOF
}

