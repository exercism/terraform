
resource "aws_security_group" "efs_repositories" {
  name        = "efs_repositories"
  description = "Allows the efs_repositories_access to access this"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group" "efs_repositories_access" {
  name        = "efs_repositories_access"
  description = "Controls what can access to the EFS"
  vpc_id      = aws_vpc.main.id

  egress {
    protocol        = "tcp"
    from_port       = 2049
    to_port         = 2049
    security_groups = [aws_security_group.efs_repositories.id]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "efs_repositories_ingress" {
  security_group_id = aws_security_group.efs_repositories.id

  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 2049
  to_port                  = 2049
  source_security_group_id = aws_security_group.efs_repositories_access.id

  lifecycle {
    create_before_destroy = true
  }
}
