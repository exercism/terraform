resource "aws_security_group" "alb" {
  name        = "sidekiq-alb"
  description = "controls access to the ALB"
  vpc_id      = var.aws_vpc_main.id

#  # TODO: Change this to only accept requests
#  # from tooling_invoker
#  ingress {
#    protocol    = "tcp"
#    from_port   = var.monitor_port
#    to_port     = var.monitor_port
#    cidr_blocks = ["0.0.0.0/0"]
#  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
    egress {
    from_port = 0
    to_port   = 0
    ipv6_cidr_blocks = [
      "::/0",
    ]
    protocol = "-1"
  }
}


