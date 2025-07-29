resource "aws_elasticache_serverless_cache" "git_cache" {
  name               = "git-cache-serverless"
  engine             = "valkey"
  subnet_ids         = var.aws_subnet_publics.*.id
  security_group_ids = [aws_security_group.elasticache_git_cache.id]

       cache_usage_limits {
           data_storage {
               maximum = 1
               unit    = "GB"
            }
        }
}