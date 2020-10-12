resource "aws_ecr_repository" "rails" {
  name                 = "webserver-rails"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration { scan_on_push = false }
}

resource "aws_ecr_repository" "anycable_go" {
  name                 = "webserver-anycable-go"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration { scan_on_push = false }
}

resource "aws_ecr_repository" "nginx" {
  name         = "webserver-nginx"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration { scan_on_push = false }
}
