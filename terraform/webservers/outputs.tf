output "anycable_redis_url" {
  value = aws_elasticache_cluster.anycable.cache_nodes.0.address
}

output "alb_hostname" {
  value = aws_alb.webservers.dns_name
}

output "rds_cluster_master_endpoint" {
  value = aws_rds_cluster.main.endpoint
}

output "rds_cluster_reader_endpoint" {
  value = aws_rds_cluster.main.reader_endpoint
}
