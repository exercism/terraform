resource "aws_elasticsearch_domain" "general" {
  domain_name           = "general"
  elasticsearch_version = "OpenSearch_1.0"

  cluster_config {
    dedicated_master_enabled = false
    dedicated_master_count   = 0

    instance_count = 2
    instance_type  = "t3.small.elasticsearch"

    warm_enabled = false

    zone_awareness_enabled = true
    zone_awareness_config {
      availability_zone_count = 2
    }
  }

  ebs_options {
    ebs_enabled = true
    iops = 0
    volume_size = 10
    volume_type = "gp2"
  }

  encrypt_at_rest {
    enabled = false
  }

  node_to_node_encryption {
    enabled = false
  }

  snapshot_options {
    automated_snapshot_start_hour = 0
  }

  timeouts {}

  vpc_options {
    subnet_ids         = [
      aws_subnet.publics[0].id,
      aws_subnet.publics[1].id
    ]
    security_group_ids = [aws_security_group.es_general.id]
  }

  domain_endpoint_options {
    custom_endpoint_enabled = false
    enforce_https           = true
    tls_security_policy     = "Policy-Min-TLS-1-0-2019-07"
  }

  advanced_options = {
    "indices.fielddata.cache.size"           = "20"
    "indices.query.bool.max_clause_count"    = "1024"
    "override_main_response_version"         = false
    "rest.action.multi.allow_explicit_index" = true
  }
  advanced_security_options {
    enabled                        = false
    internal_user_database_enabled = false
  }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.cloudsearch_general.arn
    log_type                 = "INDEX_SLOW_LOGS"
  }

  access_policies = <<POLICY
    {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": "*"
        },
        "Action": "es:*",
        "Resource": "arn:aws:es:eu-west-2:681735686245:domain/general/*"
      }
    ]
  }
  POLICY
}


resource "aws_cloudwatch_log_group" "cloudsearch_general" {
  name = "cloudsearch-general"
}

resource "aws_cloudwatch_log_resource_policy" "cloudsearch_general" {
  policy_name = "put-cloudsearch-general"

  policy_document = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Action": [
        "logs:PutLogEvents",
        "logs:PutLogEventsBatch",
        "logs:CreateLogStream"
      ],
      "Resource": "arn:aws:logs:*"
    }
  ]
}
CONFIG
}
