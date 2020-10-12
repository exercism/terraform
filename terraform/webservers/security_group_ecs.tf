resource "aws_security_group" "ecs_webservers" {
  name        = "ecs_webservers"
  description = "allow inbound access from the ALB only"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol        = "tcp"
    from_port       = var.webservers_http_port
    to_port         = var.webservers_http_port
    security_groups = [aws_security_group.alb.id]
  }

  ingress {
    protocol        = "tcp"
    from_port       = var.webservers_websockets_port
    to_port         = var.webservers_websockets_port
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
