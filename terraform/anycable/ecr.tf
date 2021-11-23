resource "aws_ecr_repository" "go" {
  name                 = "anycable-go"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration { scan_on_push = false }
}
resource "aws_ecr_repository" "go_pro" {
  name                 = "anycable-go-pro"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration { scan_on_push = false }
}


