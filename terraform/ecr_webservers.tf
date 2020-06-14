resource "aws_ecr_repository" "webservers" {
  name                 = "webservers"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
