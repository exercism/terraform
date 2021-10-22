output "webservers-cf-hostname" {
  value = module.webservers.cloudfront_distribution_webservers_hostname
}
output "webservers-alb_hostname" {
  value = module.webservers.alb_hostname
}

output "anycable_redis_url" {
  value = module.anycable.redis_url
}

output "tooling-orchestrator-alb_hostname" {
  value = module.tooling_orchestrator.alb_hostname
}

output "lines_of_code_counter_url" {
  value = module.lines_of_code_counter.invoke_url
}

output "snippet_extractor_url" {
  value = module.snippet_extractor.invoke_url
}
