resource "aws_ecr_repository" "webserver_nginx" {
  name                 = "webserver_nginx"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration { scan_on_push = false }
}

resource "aws_ecr_repository" "webserver_puma" {
  name                 = "webserver_puma"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration { scan_on_push = false }
}

resource "aws_ecr_repository" "webserver_anycable_go" {
  name                 = "webserver_anycable_go"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration { scan_on_push = false }
}

resource "aws_ecr_repository" "webserver_anycable_ruby" {
  name                 = "webserver_anycable_ruby"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration { scan_on_push = false }
}
