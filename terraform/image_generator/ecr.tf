resource "aws_ecr_repository" "image_generator" {
  name                 = "image-generator"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration { scan_on_push = false }
}
