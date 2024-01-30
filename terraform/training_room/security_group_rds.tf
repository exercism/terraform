resource "aws_security_group" "rds_main" {
  name        = "rds-training-room"
  description = "Security Group for Training Room RDS"
  vpc_id      = var.aws_vpc_main.id
}

resource "aws_security_group_rule" "rds_main_egress" {
  security_group_id = aws_security_group.rds_main.id

  type        = "egress"
  protocol    = "-1"
  from_port   = 0
  to_port     = 0
  cidr_blocks = ["0.0.0.0/0"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "rds_main_ingress" {
  security_group_id = aws_security_group.rds_main.id

  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.ecs.id
}
