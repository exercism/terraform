resource "aws_security_group" "default" {
  name        = "exercism-default"
  description = "Default values for VPC"
  vpc_id      = aws_vpc.main.id

  lifecycle {
    create_before_destroy = true
  }
}

