resource "aws_security_group_rule" "es_general" {
  security_group_id = var.aws_security_group_es_general.id

  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 443
  to_port                  = 443
  source_security_group_id = aws_security_group.ec2.id
}
