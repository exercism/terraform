resource "aws_security_group_rule" "rds_main_ingress" {
  security_group_id = var.aws_security_group_rds_main.id

  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.ec2.id
}

