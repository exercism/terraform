resource "aws_ecr_repository" "sidekiq_monitor" {
  name                 = "sidekiq-monitor"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration { scan_on_push = false }
}
