resource "aws_security_group" "ecs" {
  name        = "language-servers-ecs"
  description = "allow inbound access from the ALB only"
  vpc_id      = var.aws_vpc_main.id

  ingress {
    protocol        = "tcp"
    from_port       = var.websockets_port
    to_port         = var.websockets_port
    security_groups = [aws_security_group.alb.id]
  }

  # TODO - Change this to just have access to what it
  # needs - which I think is ECR. It shouldn't need to 
  # be pinging out to the internet.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

