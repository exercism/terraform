resource "aws_iam_role" "ec2" {
  name = "discourse-ec2"

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

# There are some eventual consistency issues with this.
#
resource "aws_iam_instance_profile" "ec2" {
  name = "discourse-ec2"
  role = aws_iam_role.ec2.name
}
