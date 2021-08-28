resource "aws_security_group" "elasticache" {
  name        = "elasticache-sidekiq"
  description = "Security Group for Elasticache sidekiq"
  vpc_id      = var.aws_vpc_main.id

  tags = {
    Name = "elasticache-sidekiq"
  }
}
