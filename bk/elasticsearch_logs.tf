resource "aws_elasticsearch_domain" "logs" {
  domain_name           = "logs"
  elasticsearch_version = "7.7"

  cluster_config {
    instance_type = "t2.small.elasticsearch"
  }

  snapshot_options {
    automated_snapshot_start_hour = 23
  }

  # TODO: Enable this and use a reverse proxy
  # to access it publically
  #
  # vpc_options {
  #   subnet_ids = [
  #     aws_subnet.publics.0.id
  #   ]

  #   security_group_ids = [
  #     aws_security_group.elasticsearch_logs.id
  #   ]
  # }
  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }

  tags = {
    Domain = "Logs"
  }

  access_policies = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "es:*",
      "Principal": "*",
      "Effect": "Allow",
      "Resource": "arn:aws:es:${var.region}:${data.aws_caller_identity.current.account_id}:domain/logs/*",
      "Condition": {
      }
    }
  ]
  
}
POLICY

  cognito_options {
    enabled          = true
    identity_pool_id = aws_cognito_identity_pool.kibana_access.id
    role_arn         = aws_iam_role.cognito_access_for_elasticsearch.arn
    user_pool_id     = aws_cognito_user_pool.kibana_access.id
  }

  depends_on = [
    aws_iam_service_linked_role.elasticsearch,
    aws_cognito_user_pool_domain.logs
  ]
}

resource "aws_cognito_user_pool" "kibana_access" {
  name = "kibana_access"
}
resource "aws_cognito_user_pool_domain" "logs" {
  domain       = "logs"
  user_pool_id = aws_cognito_user_pool.kibana_access.id
}
resource "aws_cognito_identity_pool" "kibana_access" {
  identity_pool_name               = "main"
  allow_unauthenticated_identities = false
}

resource "aws_iam_service_linked_role" "elasticsearch" {
  aws_service_name = "es.amazonaws.com"
  description      = "Allows Amazon ES to manage AWS resources for a domain on your behalf."
}
