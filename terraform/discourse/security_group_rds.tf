resource "aws_security_group" "rds_discourse" {
  name        = "discourse"
  description = "Security Group for Discourse RDS"
  vpc_id      = var.aws_vpc_main.id
}

resource "aws_security_group_rule" "rds_discourse_ingress" {
  security_group_id = aws_security_group.rds_discourse.id

  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 5432
  to_port                  = 5432
  source_security_group_id = aws_security_group.ec2.id
}

resource "aws_security_group_rule" "rds_discourse_egress" {
  security_group_id = aws_security_group.rds_discourse.id

  type        = "egress"
  protocol    = "-1"
  from_port   = 0
  to_port     = 0
  cidr_blocks = ["0.0.0.0/0"]

  lifecycle {
    create_before_destroy = true
  }
}

