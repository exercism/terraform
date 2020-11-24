resource "aws_wafv2_web_acl" "webservers" {
  name        = "webservers"
  description = "Webservers"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "AWSManagedRulesAmazonIpReputationList"
    priority = 1

    override_action { 
      none {} 
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "waf-webservers-1"
      sampled_requests_enabled   = false
    }
  }

  rule {
    name     = "AWSManagedRulesWordPressRuleSet"
    priority = 2

    override_action { 
      none {} 
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesWordPressRuleSet"
        vendor_name = "AWS"
      }
    }
  
    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "waf-webservers-2"
      sampled_requests_enabled   = false
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "waf-webservers"
    sampled_requests_enabled   = false
  }
}

resource "aws_wafv2_web_acl_association" "webservers" {
  resource_arn = aws_alb.webservers.arn
  web_acl_arn  = aws_wafv2_web_acl.webservers.arn
}
