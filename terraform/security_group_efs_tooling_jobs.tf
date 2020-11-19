resource "aws_security_group" "efs_tooling_jobs_access" {
  name        = "efs-tooling-jobs-access"
  description = "Controls what can access to the EFS"
  vpc_id      = aws_vpc.main.id

  egress {
    protocol        = "tcp"
    from_port       = 2049
    to_port         = 2049
    security_groups = [aws_security_group.efs_tooling_jobs.id]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "efs_tooling_jobs" {
  name        = "efs_tooling_jobs"
  description = "Allows the efs_tooling_jobs_access to be accessed"
  vpc_id      = aws_vpc.main.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "efs_tooling_jobs_ingress" {
  security_group_id = aws_security_group.efs_tooling_jobs.id

  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 2049
  to_port                  = 2049
  source_security_group_id = aws_security_group.efs_tooling_jobs_access.id

  lifecycle {
    create_before_destroy = true
  }
}

