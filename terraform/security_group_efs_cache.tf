resource "aws_security_group" "efs_cache_access" {
  name        = "efs-cache-access"
  description = "Controls what can access to the EFS"
  vpc_id      = aws_vpc.main.id

  egress {
    protocol        = "tcp"
    from_port       = 2049
    to_port         = 2049
    security_groups = [aws_security_group.efs_cache.id]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "efs_cache" {
  name        = "efs_cache"
  description = "Allows the efs_cache_access to be accessed"
  vpc_id      = aws_vpc.main.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "efs_cache_ingress" {
  security_group_id = aws_security_group.efs_cache.id

  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 2049
  to_port                  = 2049
  source_security_group_id = aws_security_group.efs_cache_access.id

  lifecycle {
    create_before_destroy = true
  }
}

