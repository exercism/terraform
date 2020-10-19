resource "aws_iam_role" "ec2" {
  name = "tooling-invoker-ec2"

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

resource "aws_iam_role_policy_attachment" "ecr" {
  role       = aws_iam_role.ec2.name
  policy_arn = aws_iam_policy.ecr.arn
}
resource "aws_iam_role_policy_attachment" "dynamodb_config" {
  role       = aws_iam_role.ec2.name
  policy_arn = var.aws_iam_policy_read_dynamodb_config_arn
}
resource "aws_iam_role_policy_attachment" "dynamodb_tooling_language_groups" {
  role       = aws_iam_role.ec2.name
  policy_arn = var.aws_iam_policy_read_dynamodb_tooling_language_groups_arn
}

resource "aws_iam_role_policy_attachment" "read_s3_bucket_submissions" {
  role       = aws_iam_role.ec2.name
  policy_arn = var.aws_iam_policy_read_s3_bucket_submissions.arn
}

resource "aws_iam_role_policy" "read_ec2_tags" {
  name = "tooling-invoker-ec2-tags"
  role       = aws_iam_role.ec2.name
  policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [{
      "Effect": "Allow",
      "Action": [ "ec2:DescribeTags" ],
      "Resource": "*"
   }]
}
EOF
}


# There are some eventual consistency issues with this.
#
resource "aws_iam_instance_profile" "ec2" {
  name = "tooling-invoker-ec2"
  role = aws_iam_role.ec2.name
}
