resource "aws_security_group" "elasticache_git_cache" {
  name        = "git_cache"
  description = "Security Group for Elasticache Git Cache"
  vpc_id      = var.aws_vpc_main.id

  tags = {
    Name = "elasticache-git-cache"
  }
}
resource "aws_security_group" "elasticache_git_cache_access" {
  name        = "git_cache_access"
  description = "Security Group for Access to Elasticache Git Cache"
  vpc_id      = var.aws_vpc_main.id

  tags = {
    Name = "elasticache-git-cache-access"
  }
}

resource "aws_security_group_rule" "elasticache_git_cache_access_ingress" {
  security_group_id = aws_security_group.elasticache_git_cache.id

  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 6379
  to_port                  = 6379
  source_security_group_id = aws_security_group.elasticache_git_cache_access.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "elasticache_git_cache_ingress" {
  security_group_id = aws_security_group.elasticache_git_cache.id

  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 6379
  to_port                  = 6379
  source_security_group_id = aws_security_group.ecs.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "elasticache_git_cache_egress" {
  security_group_id = aws_security_group.elasticache_git_cache.id

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  lifecycle {
    create_before_destroy = true
  }
}

