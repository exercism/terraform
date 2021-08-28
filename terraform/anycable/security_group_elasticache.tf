resource "aws_security_group" "elasticache" {
  name        = "anycable"
  description = "Security Group for Elasticache AnyCable"
  vpc_id      = var.aws_vpc_main.id

  tags = {
    Name = "elasticache-anycable"
  }
}

resource "aws_security_group_rule" "elasticache_egress" {
  security_group_id = aws_security_group.elasticache.id

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  lifecycle {
    create_before_destroy = true
  }
}

