data "aws_cloudfront_origin_request_policy" "Managed-UserAgentRefererHeaders" {
  name = "Managed-UserAgentRefererHeaders"
}

resource "aws_cloudfront_distribution" "metrics_redirect" {
  enabled         = true
  is_ipv6_enabled = true

  aliases = [
    "mail-metrics.exercism.org"
  ]

  viewer_certificate {
    acm_certificate_arn      = "arn:aws:acm:us-east-1:681735686245:certificate/2606116b-77f6-40bc-a674-656effebe65e"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  #####################
  ## Generated images #
  #####################
  origin {
    domain_name = "r.eu-west-2.awstrack.me"
    origin_id   = "r.eu-west-2.awstrack.me"

    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "match-viewer"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    viewer_protocol_policy = "allow-all"
    target_origin_id       = "r.eu-west-2.awstrack.me"

    cache_policy_id          = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }


}
