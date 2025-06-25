resource "aws_elasticache_subnet_group" "main" {
  name       = "anycable"
  subnet_ids = var.aws_subnet_publics.*.id
}

resource "aws_elasticache_cluster" "main" {
  cluster_id           = "anycable"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis6.x"
  engine_version       = "6.x"
  port                 = 6379
  availability_zone    = data.aws_availability_zones.available.names[0]
  subnet_group_name    = aws_elasticache_subnet_group.main.name
  security_group_ids   = [aws_security_group.elasticache.id]
}

resource "aws_elasticache_serverless_cache" "main" {
  name               = "anycable-serverless"
  engine             = "valkey"
  subnet_ids         = var.aws_subnet_publics.*.id
  security_group_ids = [aws_security_group.elasticache.id]
}