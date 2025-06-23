resource "aws_security_group" "elasticache_cache" {
  name        = "cache"
  description = "Security Group for Elasticache Cache"
  vpc_id      = var.aws_vpc_main.id

  tags = {
    Name = "elasticache-cache"
  }
}

resource "aws_security_group_rule" "elasticache_cache_ingress" {
  security_group_id = aws_security_group.elasticache_cache.id

  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 6379
  to_port                  = 6379
  source_security_group_id = aws_security_group.ecs.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "elasticache_cache_egress" {
  security_group_id = aws_security_group.elasticache_cache.id

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  lifecycle {
    create_before_destroy = true
  }
}

