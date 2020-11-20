resource "aws_ecr_repository" "proxy" {
  name                 = "language-servers-proxy"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration { scan_on_push = false }
}
