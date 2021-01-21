resource "aws_security_group" "efs_submissions_access" {
  name        = "efs-submissions-access"
  description = "Controls what can access to the EFS"
  vpc_id      = aws_vpc.main.id

  egress {
    protocol        = "tcp"
    from_port       = 2049
    to_port         = 2049
    security_groups = [aws_security_group.efs_submissions.id]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "efs_submissions" {
  name        = "efs_submissions"
  description = "Allows the efs_submissions_access to be accessed"
  vpc_id      = aws_vpc.main.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "efs_submissions_ingress" {
  security_group_id = aws_security_group.efs_submissions.id

  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 2049
  to_port                  = 2049
  source_security_group_id = aws_security_group.efs_submissions_access.id

  lifecycle {
    create_before_destroy = true
  }
}

