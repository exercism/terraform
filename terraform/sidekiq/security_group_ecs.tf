resource "aws_security_group" "ecs" {
  name        = "sidekiq-ecs"
  description = "allow outbound access"
  vpc_id      = var.aws_vpc_main.id

  # TODO - Change this to just have access to what it
  # needs - which I think is ECR. It shouldn't need to 
  # be pinging out to the internet.
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

