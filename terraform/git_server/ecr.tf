resource "aws_ecr_repository" "nginx" {
  name                 = "git-server-nginx"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration { scan_on_push = false }
}

resource "aws_ecr_repository" "application" {
  name                 = "git-server-application"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration { scan_on_push = false }
}
