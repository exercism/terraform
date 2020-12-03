resource "aws_iam_policy" "read_secret_config" {
  name        = "access-secret-config"
  path        = "/"
  description = "Access the config Secret from SecretsManager"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": [
        "secretsmanager:GetResourcePolicy",
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret",
        "secretsmanager:ListSecretVersionIds"
    ],
    "Resource": "${aws_secretsmanager_secret.config.arn}"
  }]
}
EOF
}
