resource "aws_elasticache_subnet_group" "tooling" {
  name       = "tooling"
  subnet_ids = aws_subnet.publics.*.id
}

resource "aws_elasticache_cluster" "tooling" {
  cluster_id           = "tooling"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis5.0"
  engine_version       = "5.0.6"
  port                 = 6379
  availability_zone    = data.aws_availability_zones.available.names[0]
  subnet_group_name    = aws_elasticache_subnet_group.tooling.name
  security_group_ids   = [aws_security_group.elasticache_tooling.id]


  # lifecycle {
  #   ignore_changes = [engine_version]
  # }
}

