resource "aws_ecr_repository" "lines_of_code_counter" {
  name                 = "lines-of-code-counter"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration { scan_on_push = false }
}
