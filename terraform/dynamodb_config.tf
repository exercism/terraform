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

resource "aws_dynamodb_table_item" "website_url" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key

  item = <<ITEM
{
  "id": {"S": "website_url"},
  "value": {"S": "${local.website_protocol}://${local.website_host}"}
}
ITEM
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

resource "aws_dynamodb_table_item" "websockets_url" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key

  item = <<ITEM
{
  "id": {"S": "websockets_url"},
  "value": {"S": "${local.websockets_protocol}://${local.website_host}"}
}
ITEM
}

resource "aws_dynamodb_table_item" "spi_url" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key

  item = <<ITEM
{
  "id": {"S": "spi_url"},
  "value": {"S": "https://internal.exercism.org"}
}
ITEM
}

resource "aws_dynamodb_table_item" "anycable_redis_url" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key

  item = <<ITEM
{
  "id": {"S": "anycable_redis_url"},
  "value": {"S": "redis://${module.anycable.redis_url}"}
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

resource "aws_dynamodb_table_item" "sidekiq_redis_url" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key

  item = <<ITEM
{
  "id": {"S": "sidekiq_redis_url"},
  "value": {"S": "redis://${module.sidekiq.redis_url}"}
}
ITEM
}

resource "aws_dynamodb_table_item" "assets_host" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key

  item = <<ITEM
{
  "id": {"S": "website_assets_host"},
  "value": {"S": "https://assets.exercism.org"}
}
ITEM
}

resource "aws_dynamodb_table_item" "avatars_host" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key

  item = <<ITEM
{
  "id": {"S": "website_avatars_host"},
  "value": {"S": "https://assets.exercism.org/avatars"}
}
ITEM
}

resource "aws_dynamodb_table_item" "website_assets_cloudfront_distribution_id" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key

  item = <<ITEM
{
  "id": {"S": "website_assets_cloudfront_distribution_id"},
  "value": {"S": "${module.files.cloudfront_distribution_assets.id}"}
}
ITEM
}

resource "aws_dynamodb_table_item" "aws_attachments_region" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key

  item = <<ITEM
{
  "id": {"S": "aws_attachments_region"},
  "value": {"S": "${var.region}"}
}
ITEM
}
resource "aws_dynamodb_table_item" "aws_attachments_bucket" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key

  item = <<ITEM
{
  "id": {"S": "aws_attachments_bucket"},
  "value": {"S": "${local.s3_bucket_attachments_name}"}
}
ITEM
}

resource "aws_dynamodb_table_item" "icons_host" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key

  item = <<ITEM
{
  "id": {"S": "website_icons_host"},
  "value": {"S": "https://assets.exercism.org"}
}
ITEM
}

resource "aws_dynamodb_table_item" "mysql_master_endpoint" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key

  item = <<ITEM
{
  "id": {"S": "mysql_master_endpoint"},
  "value": {"S": "${aws_rds_cluster.main.endpoint}"}
}
ITEM
}

resource "aws_dynamodb_table_item" "mysql_reader_endpoint" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key

  item = <<ITEM
{
  "id": {"S": "mysql_reader_endpoint"},
  "value": {"S": "${aws_rds_cluster.main.reader_endpoint}"}
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

resource "aws_dynamodb_table_item" "mysql_socket" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key

  item = <<ITEM
{
  "id": {"S": "mysql_socket"},
  "value": {"S": ""}
}
ITEM
}

resource "aws_dynamodb_table_item" "tooling_redis_url" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key

  item = <<ITEM
{
  "id": {"S": "tooling_redis_url"},
  "value": {"S": "redis://${module.tooling.redis_url}"}
}
ITEM
}

resource "aws_dynamodb_table_item" "dynamodb_tooling_language_groups_table" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key

  item = <<ITEM
{
  "id": {"S": "dynamodb_tooling_language_groups_table"},
  "value": {"S": "tooling_language_groups"}
}
ITEM
}

resource "aws_dynamodb_table_item" "aws_submissions_bucket" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key

  item = <<ITEM
{
  "id": {"S": "aws_submissions_bucket"},
  "value": {"S": "${local.s3_bucket_submissions_name}"}
}
ITEM
}

resource "aws_dynamodb_table_item" "aws_tooling_jobs_bucket" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key

  item = <<ITEM
{
  "id": {"S": "aws_tooling_jobs_bucket"},
  "value": {"S": "${local.s3_bucket_tooling_jobs_name}"}
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

resource "aws_dynamodb_table_item" "tooling_ecr_repository_url" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key

  item = <<ITEM
{
  "id": {"S": "tooling_ecr_repository_url"},
  "value": {"S": "${module.tooling.ecr_repository_url}"}
}
ITEM
}

resource "aws_dynamodb_table_item" "language_server_url" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key
  item       = <<ITEM
{
  "id": {"S": "language_server_url"},
  "value": {"S": "${module.language_servers.alb_hostname}"}
}
ITEM
}

resource "aws_dynamodb_table_item" "efs_submissions_mount_point" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key
  item       = <<ITEM
{
  "id": {"S": "efs_submissions_mount_point"},
  "value": {"S": "${local.efs_submissions_mount_point}"}
}
ITEM
}

resource "aws_dynamodb_table_item" "efs_repositories_mount_point" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key
  item       = <<ITEM
{
  "id": {"S": "efs_repositories_mount_point"},
  "value": {"S": "${local.efs_repositories_mount_point}"}
}
ITEM
}

resource "aws_dynamodb_table_item" "github_organization" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key

  item = <<ITEM
{
  "id": {"S": "github_organization"},
  "value": {"S": "exercism"}
}
ITEM
}

resource "aws_dynamodb_table_item" "github_bot_username" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key

  item = <<ITEM
{
  "id": {"S": "github_bot_username"},
  "value": {"S": "exercism-bot"}
}
ITEM
}

resource "aws_dynamodb_table_item" "opensearch_host" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key

  item = <<ITEM
{
  "id": {"S": "opensearch_host"},
  "value": {"S": "https://${aws_elasticsearch_domain.general.endpoint}"}
}
ITEM
}

resource "aws_dynamodb_table_item" "chatgpt_proxy_url" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key

  item = <<ITEM
{
  "id": {"S": "chatgpt_proxy_url"},
  "value": {"S": "https://internal.exercism.org/ask_chatgpt"}
}
ITEM
}

resource "aws_dynamodb_table_item" "snippet_generator_url" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key

  item = <<ITEM
{
  "id": {"S": "snippet_generator_url"},
  "value": {"S": "https://internal.exercism.org/extract_snippet"}
}
ITEM
}

resource "aws_dynamodb_table_item" "lines_of_code_counter_url" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key

  item = <<ITEM
{
  "id": {"S": "lines_of_code_counter_url"},
  "value": {"S": "https://internal.exercism.org/count_lines_of_code"}
}
ITEM
}

resource "aws_dynamodb_table_item" "image_generator_url" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key

  item = <<ITEM
{
  "id": {"S": "image_generator_url"},
  "value": {"S": "https://internal.exercism.org/generate_image"}
}
ITEM
}


resource "aws_dynamodb_table_item" "paypal_api_url" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key

  item = <<ITEM
{
  "id": {"S": "paypal_api_url"},
  "value": {"S": "https://api-m.paypal.com"}
}
ITEM
}

resource "aws_dynamodb_table_item" "paypal_url" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key

  item = <<ITEM
{
  "id": {"S": "paypal_url"},
  "value": {"S": "https://www.paypal.com"}
}
ITEM
}

resource "aws_dynamodb_table_item" "tooling_cloudwatch_jobs_log_group_name" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key
  item       = <<ITEM
{
  "id": {"S": "tooling_cloudwatch_jobs_log_group_name"},
  "value": {"S": "${module.tooling.aws_cloudwatch_jobs_log_group.name}"}
}
ITEM
}

resource "aws_dynamodb_table_item" "tooling_cloudwatch_jobs_log_stream_name" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key
  item       = <<ITEM
{
  "id": {"S": "tooling_cloudwatch_jobs_log_stream_name"},
  "value": {"S": "${module.tooling.aws_cloudwatch_log_stream_jobs_general.name}"}
}
ITEM
}

resource "aws_dynamodb_table_item" "mongodb_url" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key
  item       = <<ITEM
{
  "id": {"S": "mongodb_url"},
  "value": {"S": "mongodb://exercism:exercism@${aws_docdb_cluster.general.endpoint}:${aws_docdb_cluster.general.port}/?replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false"}
}
ITEM
}

resource "aws_dynamodb_table_item" "mongodb_database_name" {
  table_name = aws_dynamodb_table.config.name
  hash_key   = aws_dynamodb_table.config.hash_key
  item       = <<ITEM
{
  "id": {"S": "mongodb_database_name"},
  "value": {"S": "exercism"}
}
ITEM
}



