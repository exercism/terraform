resource "aws_ecr_repository" "translator" {
  name                 = "translator"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration { scan_on_push = false }
}
