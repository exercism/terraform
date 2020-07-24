# ECS task execution role data
data "aws_iam_policy_document" "cognito_access_for_elasticsearch" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["es.amazonaws.com"]
    }
  }
}

# ECS task execution role
resource "aws_iam_role" "cognito_access_for_elasticsearch" {
  name               = "cognito_access_for_elasticsearch"
  assume_role_policy = data.aws_iam_policy_document.cognito_access_for_elasticsearch.json
}

# ECS task execution role policy attachment
resource "aws_iam_role_policy_attachment" "cognito_access_for_elasticsearch" {
  role       = aws_iam_role.cognito_access_for_elasticsearch.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonESCognitoAccess"
}

