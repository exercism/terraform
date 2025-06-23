
resource "aws_elasticache_subnet_group" "jobs" {
  name       = "tooling-jobs"
  subnet_ids = var.aws_subnet_publics.*.id
}

resource "aws_elasticache_serverless_cache" "tooling_jobs" { 
  name = "tooling-jobs-serverless"
  engine               = "valkey"
  subnet_ids           = var.aws_subnet_publics.*.id
  security_group_ids   = [aws_security_group.elasticache_jobs.id]
}
