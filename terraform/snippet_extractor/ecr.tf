resource "aws_ecr_repository" "snippet_extractor" {
  name                 = "generic-snippet-extractor"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration { scan_on_push = false }
}
