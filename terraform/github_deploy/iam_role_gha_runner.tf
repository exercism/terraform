resource "aws_iam_role" "ec2" {
  name = "gha-runner-ec2"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
         "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "read_dynamodb_config" {
  role       = aws_iam_role.ec2.name
  policy_arn = var.aws_iam_policy_read_dynamodb_config.arn
}

resource "aws_iam_role_policy_attachment" "read_secret_config" {
  role       = aws_iam_role.ec2.name
  policy_arn = var.aws_iam_policy_read_secret_config.arn
}
resource "aws_iam_instance_profile" "ec2" {
  name = "gha-runner-ec2"
  role = aws_iam_role.ec2.name
}
