resource "aws_ecr_repository" "repos" {
  for_each = var.ecr_tooling_repos
  name     = each.key

  image_tag_mutability = "MUTABLE"
  image_scanning_configuration { scan_on_push = false }
}

resource "aws_ecr_lifecycle_policy" "repos" {
  for_each   = var.ecr_tooling_repos
  repository = each.key

  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep one production image",
      "selection": {
        "tagStatus": "tagged",
        "tagPatternList": [
          "production"
        ],
        "countType": "imageCountMoreThan",
        "countNumber": 1
      },
      "action": {
        "type": "expire"
      }
    },
    {
      "rulePriority": 2,
      "description": "Expire everything else",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 1
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}