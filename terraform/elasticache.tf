resource "aws_elasticache_subnet_group" "anycable" {
  name       = "tf-test-cache-subnet"
  subnet_ids = aws_subnet.publics.*.id
}

resource "aws_elasticache_cluster" "anycable" {
  cluster_id           = "anycable"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  engine_version       = "3.2.10"
  port                 = 6379
  availability_zone    = local.az_names[0]
  subnet_group_name    = aws_elasticache_subnet_group.anycable.name
  security_group_ids   = [aws_security_group.elasticache_anycable.id]
}
