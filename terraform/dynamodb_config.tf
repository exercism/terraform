resource "aws_dynamodb_table" "config" {
  name           = "config"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_dynamodb_table_item" "webservers_alb_dns_name" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key

  item = <<ITEM
{
  "id": {"S": "webservers_alb_dns_name"},
  "value": {"S": "${module.webservers.alb_hostname}"}
}
ITEM
}

resource "aws_dynamodb_table_item" "anycable_redis_url" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key

  item = <<ITEM
{
  "id": {"S": "anycable_redis_url"},
  "value": {"S": "${module.webservers.anycable_redis_url}"}
}
ITEM
}

resource "aws_dynamodb_table_item" "anycable_rpc_host" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key

  item = <<ITEM
{
  "id": {"S": "anycable_rpc_host"},
  "value": {"S": "127.0.0.1:50051"}
}
ITEM
}


resource "aws_dynamodb_table_item" "mysql_master_endpoint" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key

  item = <<ITEM
{
  "id": {"S": "mysql_master_endpoint"},
  "value": {"S": "${module.webservers.rds_cluster_master_endpoint}"}
}
ITEM
}

resource "aws_dynamodb_table_item" "mysql_reader_endpoint" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key

  item = <<ITEM
{
  "id": {"S": "mysql_reader_endpoint"},
  "value": {"S": "${module.webservers.rds_cluster_reader_endpoint}"}
}
ITEM
}

resource "aws_dynamodb_table_item" "mysql_port" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key

  item = <<ITEM
{
  "id": {"S": "mysql_port"},
  "value": {"S": "3306"}
}
ITEM
}

resource "aws_dynamodb_table_item" "dynamodb_tooling_jobs_table" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key

  item = <<ITEM
{
  "id": {"S": "dynamodb_tooling_jobs_table"},
  "value": {"S": "tooling_jobs"}
}
ITEM
}

resource "aws_dynamodb_table_item" "aws_iterations_bucket" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key

  item = <<ITEM
{
  "id": {"S": "aws_iterations_bucket"},
  "value": {"S": "exercism-staging-iterations"}
}
ITEM
}

resource "aws_dynamodb_table_item" "tooling_orchestrator_url" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key

  item = <<ITEM
{
  "id": {"S": "tooling_orchestrator_url"},
  "value": {"S": "${module.tooling_orchestrator.alb_hostname}"}
}
ITEM
}

