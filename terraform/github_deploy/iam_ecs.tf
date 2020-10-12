
# TODO: Limit the resources here in the same 
# way we do for ECR.
resource "aws_iam_user_policy" "ecs" {
  name = "github-deploy-ecs"
  user = local.username

  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "GithubDeployECSTaskDefinitionPolicy",
        "Effect": "Allow",
        "Action": [
            "ecs:RegisterTaskDefinition",
            "ecs:ListTaskDefinitions",
            "ecs:DescribeTaskDefinition"
        ],
        "Resource": ["*"]
    }
  ]
}
EOF
}
