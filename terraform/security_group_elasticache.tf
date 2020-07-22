resource "aws_security_group" "elasticache_anycable" {
  name        = "elasticache anycable"
  description = "Security Group for Elasticache AnyCable"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "elasticache-anycable"
  }

  ingress {
    protocol        = "tcp"
    from_port       = 6379
    to_port         = 6379
    security_groups = [aws_security_group.webservers.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

