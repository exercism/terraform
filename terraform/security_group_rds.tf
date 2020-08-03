resource "aws_security_group" "rds" {
  name        = "v3 RDS"
  description = "Security Group for V3 RDS"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "v3 RDS"
  }

  ingress {
    protocol        = "tcp"
    from_port       = 3306
    to_port         = 3306
    security_groups = [aws_security_group.ecs_webservers.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on = [ aws_security_group.ecs_webservers ]
}
