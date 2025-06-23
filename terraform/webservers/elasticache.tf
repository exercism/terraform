resource "aws_elasticache_serverless_cache" "cache" { 
  name = "cache-serverless"
  engine               = "valkey"
  subnet_ids           = var.aws_subnet_publics.*.id
  security_group_ids   = [aws_security_group.elasticache_cache.id]
}