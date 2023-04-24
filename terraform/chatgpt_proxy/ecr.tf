resource "aws_ecr_repository" "chatgpt_proxy" {
  name                 = "chatgpt-proxy"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration { scan_on_push = false }
}
