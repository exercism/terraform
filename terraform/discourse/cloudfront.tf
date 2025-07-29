data "aws_cloudfront_origin_request_policy" "Managed-UserAgentRefererHeaders" {
  name = "Managed-UserAgentRefererHeaders"
}

locals {
  origin_id_alb = "ALB-${aws_alb.discourse.name}"
}

resource "aws_cloudfront_distribution" "discourse" {
  enabled         = false
  is_ipv6_enabled = true
  aliases         = ["forum.exercism.org"]

  origin {
    domain_name = aws_alb.discourse.dns_name
    origin_id   = local.origin_id_alb

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2", "SSLv3"]
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.origin_id_alb
  cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  origin_request_policy_id = "33f36d7e-f396-46d9-90e0-52428a34d9dc" 
  compress = true


    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_certificate_arn
    ssl_support_method  = "sni-only"
  }
}

