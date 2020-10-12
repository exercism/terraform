resource "aws_ecr_repository" "application" {
  name                 = "tooling-orchestrator-application"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration { scan_on_push = false }
}

resource "aws_ecr_repository" "nginx" {
  name                 = "tooling-orchestrator-nginx"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration { scan_on_push = false }
}
