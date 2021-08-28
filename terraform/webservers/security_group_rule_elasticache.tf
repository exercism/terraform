resource "aws_security_group_rule" "elasticache_anycable_ingress" {
  security_group_id = var.aws_security_group_elasticache_anycable.id

  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 6379
  to_port                  = 6379
  source_security_group_id = aws_security_group.ecs.id
}

