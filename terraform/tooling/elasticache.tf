resource "aws_elasticache_subnet_group" "jobs" {
  name       = "tooling-jobs"
  subnet_ids = var.aws_subnet_publics.*.id
}

resource "aws_elasticache_cluster" "jobs" {
  cluster_id           = "tooling-jobs"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis5.0"
  engine_version       = "5.0.6"
  port                 = 6379
  availability_zone    = data.aws_availability_zones.available.names[0]
  subnet_group_name    = aws_elasticache_subnet_group.jobs.name
  security_group_ids   = [aws_security_group.elasticache_jobs.id]


  # lifecycle {
  #   ignore_changes = [engine_version]
  # }
}
