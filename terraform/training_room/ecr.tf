resource "aws_ecr_repository" "nginx" {
  name                 = "training-room-nginx"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration { scan_on_push = false }
}

resource "aws_ecr_repository" "application" {
  name                 = "training-room-application"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration { scan_on_push = false }
}

