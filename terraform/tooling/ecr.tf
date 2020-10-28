resource "aws_ecr_repository" "repos" {
  for_each = var.ecr_tooling_repos
  name = each.key

  image_tag_mutability = "MUTABLE"
  image_scanning_configuration { scan_on_push = false }
}
