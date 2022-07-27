resource "aws_iam_user_policy" "s3" {
  name = "github-deploy-s3"
  user = local.username

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "GithubDeployS3ListPolicy",
        "Effect": "Allow",
        "Action": ["s3:ListBucket"],
        "Resource": [
          "arn:aws:s3:::${var.aws_s3_bucket_name_assets}",
          "arn:aws:s3:::${var.aws_s3_bucket_name_icons}",
          "arn:aws:s3:::${var.aws_s3_bucket_name_tracks_dashboard}"
        ]
      }, {
        "Sid": "GithubDeployS3ReadWritePolicy",
        "Effect": "Allow",
        "Action": [
          "s3:GetObject",
          "s3:PutObject",
          "s3:PutObjectAcl"
        ],
        "Resource": [
          "arn:aws:s3:::${var.aws_s3_bucket_name_assets}/*",
          "arn:aws:s3:::${var.aws_s3_bucket_name_icons}/*",
          "arn:aws:s3:::${var.aws_s3_bucket_name_tracks_dashboard}/*"
        ]
      }
    ]
}
EOF
}

