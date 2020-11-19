resource "aws_security_group" "alb" {
  name        = "git-server-alb"
  description = "controls access to the ALB"
  vpc_id      = var.aws_vpc_main.id

  ingress {
    protocol    = "tcp"
    from_port   = var.http_port
    to_port     = var.http_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
