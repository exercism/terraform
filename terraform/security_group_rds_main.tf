resource "aws_security_group" "rds_main" {
  name        = "main"
  description = "Security Group for Main RDS"
  vpc_id      = aws_vpc.main.id
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
