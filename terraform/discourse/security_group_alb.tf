resource "aws_security_group" "alb" {
  name        = "discourse-alb"
  description = "controls access to the ALB"
  vpc_id      = var.aws_vpc_main.id

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = var.cloudflare_ipv4_ranges
  }
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    ipv6_cidr_blocks = var.cloudflare_ipv6_ranges
  }

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

  lifecycle {
    create_before_destroy = true
  }
}