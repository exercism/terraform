resource "aws_security_group" "ecs_webservers" {
  name        = "ecs_webservers"
  description = "allow inbound access from the ALB only"
  vpc_id      = var.aws_vpc_main.id

  ingress {
    protocol        = "tcp"
    from_port       = var.http_port
    to_port         = var.http_port
    security_groups = [aws_security_group.webservers_alb.id]
  }

  ingress {
    protocol        = "tcp"
    from_port       = var.websockets_port
    to_port         = var.websockets_port
    security_groups = [aws_security_group.webservers_alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
