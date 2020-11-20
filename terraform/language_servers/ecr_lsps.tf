resource "aws_ecr_repository" "language_servers" {
  for_each = var.ecr_language_server_repos
  name     = each.key

  image_tag_mutability = "MUTABLE"
  image_scanning_configuration { scan_on_push = false }
}
