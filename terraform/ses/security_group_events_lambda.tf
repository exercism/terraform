resource "aws_security_group" "events_lambda" {
  name        = "ses-events-lambda"
  description = "allow outgoing access"
  vpc_id      = var.aws_vpc_main.id

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



