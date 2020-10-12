resource "aws_security_group" "ecs" {
  name        = "tooling-orchestrator-ecs"
  description = "allow inbound access from the ALB only"
  vpc_id      = var.aws_vpc_main.id

  ingress {
    protocol        = "tcp"
    from_port       = var.http_port
    to_port         = var.http_port
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

