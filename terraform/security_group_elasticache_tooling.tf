resource "aws_security_group" "elasticache_tooling" {
  name        = "webservers-elasticache-tooling"
  description = "Security Group for Elasticache tooling"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "webservers-elasticache-tooling"
  }
}

resource "aws_security_group_rule" "elasticache_tooling_ingress_webservers" {
  security_group_id = aws_security_group.elasticache_tooling.id

  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 6379
  to_port                  = 6379
  source_security_group_id = module.webservers.security_group_ecs.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "elasticache_tooling_ingress_tooling_orchestrator" {
  security_group_id = aws_security_group.elasticache_tooling.id

  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 6379
  to_port                  = 6379
  source_security_group_id = module.tooling_orchestrator.security_group_ecs.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "elasticache_tooling_ingress_sidekiq" {
  security_group_id = aws_security_group.elasticache_tooling.id

  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 6379
  to_port                  = 6379
  source_security_group_id = module.sidekiq.security_group_ecs.id

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_security_group_rule" "elasticache_tooling_egress" {
  security_group_id = aws_security_group.elasticache_tooling.id

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  lifecycle {
    create_before_destroy = true
  }
}

