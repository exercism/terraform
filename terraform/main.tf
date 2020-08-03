variable "region" {}
variable "webservers_http_port" {}
variable "webservers_websockets_port" {}
variable "webservers_cpu" {}
variable "webservers_memory" {}
variable "webservers_image" {}
variable "webservers_count" {}
provider "aws" {
  region  = var.region
  profile = "exercism_terraform"
  version = "~> 2.64"
}

# Fetch AZs in the current region
data "aws_availability_zones" "available" {}


locals {
  anycable_redis_url = "redis://${aws_elasticache_cluster.anycable.cache_nodes.0.address}:6379/1"
}

