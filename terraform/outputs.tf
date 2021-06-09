output "webservers-cf-hostname" {
  value = module.webservers.cloudfront_distribution_webservers_hostname
}
output "webservers-alb_hostname" {
  value = module.webservers.alb_hostname
}

output "webservers-anycable_redis_url" {
  value = module.webservers.anycable_redis_url
}

output "tooling-orchestrator-alb_hostname" {
  value = module.tooling_orchestrator.alb_hostname
}

output "plausible-endpoint" {
  value = module.webservers.api_gateway_invoke_url_plausible
}
