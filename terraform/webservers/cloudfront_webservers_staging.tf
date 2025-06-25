resource "aws_cloudfront_distribution" "staging" {
  enabled         = true
  is_ipv6_enabled = true

  origin {
    domain_name = "staging.exercism.org"
    origin_id   = local.origin_id_alb

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2", "SSLv3"]
    }
  }

  default_cache_behavior {
    allowed_methods          = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods           = ["GET", "HEAD"]
    target_origin_id         = local.origin_id_alb
    cache_policy_id          = aws_cloudfront_cache_policy.main.id
    origin_request_policy_id = "33f36d7e-f396-46d9-90e0-52428a34d9dc"
    compress                 = true

    viewer_protocol_policy = "redirect-to-https"

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.set_x_if_none_match.arn
    }

    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 0
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn      = "arn:aws:acm:us-east-1:681735686245:certificate/ee32787e-fb3a-45ce-8fcb-a52bb65f039d"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}