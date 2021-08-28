resource "aws_security_group" "elasticache_jobs" {
  name        = "elasticache-tooling-jobs"
  description = "Security Group for Elasticache tooling"
  vpc_id      = var.aws_vpc_main.id

  tags = {
    Name = "elasticache-tooling"
  }
}

resource "aws_security_group_rule" "elasticache_tooling_egress" {
  security_group_id = aws_security_group.elasticache_jobs.id

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  lifecycle {
    create_before_destroy = true
  }
}

