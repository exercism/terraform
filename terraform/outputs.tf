output "webservers-cf-hostname" {
  value = module.webservers.cloudfront_distribution_webservers.domain_name
}
output "webservers-alb_hostname" {
  value = module.webservers.alb_hostname
}
output "anycable_redis_url" {
  value = module.anycable.redis_url
}
output "discourse-db_hostname" {
  value = module.discourse.rds_cluster_endpoint
}
