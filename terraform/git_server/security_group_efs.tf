resource "aws_security_group" "efs" {
  name        = "git-server-efs"
  description = "controls access to the EFS"
  vpc_id      = var.aws_vpc_main.id

  ingress {
    protocol        = "tcp"
    from_port       = 2049
    to_port         = 2049
    security_groups = [aws_security_group.ecs.id]
  }

  lifecycle {
    create_before_destroy = true
  }

  # egress {
  #   from_port   = 0
  #   to_port     = 0
  #   protocol    = "-1"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }
}
