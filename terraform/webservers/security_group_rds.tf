resource "aws_security_group" "rds" {
  name        = "webservers-rds"
  description = "Security Group for Webservers RDS"
  vpc_id      = var.aws_vpc_main.id
  tags = {
    Name = "v3 RDS"
  }

  ingress {
    protocol        = "tcp"
    from_port       = 3306
    to_port         = 3306
    security_groups = [aws_security_group.ecs.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}
