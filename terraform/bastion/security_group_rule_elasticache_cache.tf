resource "aws_security_group_rule" "elasticache_cache_ingress" {
  security_group_id = var.aws_security_group_elasticache_cache.id

  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 6379
  to_port                  = 6379
  source_security_group_id = aws_security_group.ec2.id
}


