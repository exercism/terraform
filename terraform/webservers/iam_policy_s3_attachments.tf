resource "aws_iam_policy" "s3" {
  name = "webservers-write-s3-attachments"
  path        = "/"
  description = "Write attachments to s3"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": ["s3:ListBucket"],
        "Resource": ["${aws_s3_bucket.attachments.arn}"]
      }, {
        "Effect": "Allow",
        "Action": [
          "s3:GetObject",
          "s3:PutObject",
          "s3:PutObjectAcl"
        ],
        "Resource": ["${aws_s3_bucket.attachments.arn}/*"]
      }
    ]
}
EOF
}


