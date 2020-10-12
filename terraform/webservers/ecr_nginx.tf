resource "aws_ecr_repository" "nginx" {
  name         = "webserver-nginx"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration { scan_on_push = false }
}

resource "aws_ecr_repository_policy" "nginx-github-deploy" {
  repository  = aws_ecr_repository.nginx.name

  policy    = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "GitHubDeploy",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::${local.aws_account_id}:user/github-deploy"
        ]
      },
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability",
        "ecr:PutImage"
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload"
      ]
    },
    {
      "Sid": "ECSAccess",
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
        "AWS": [
          "arn:aws:iam::${local.aws_account_id}:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
        ]
      },
      "Action": [
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer"
      ]
    }
  ]
}
EOF
}
