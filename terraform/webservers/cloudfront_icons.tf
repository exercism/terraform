locals {
  s3_icons_origin_id = "icons"
}

resource "aws_cloudfront_origin_access_identity" "icons" {
  comment = "Original Access Identity for icons"
}

resource "aws_cloudfront_distribution" "icons" {
  enabled         = true
  is_ipv6_enabled = true

  origin {
    domain_name = aws_s3_bucket.icons.bucket_regional_domain_name
    origin_id   = local.s3_icons_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.icons.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_icons_origin_id

    forwarded_values {
      query_string = false
      headers      = ["Origin", "Access-Control-Request-Headers", "Access-Control-Request-Method"]

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl            = 31536000
    default_ttl            = 31536000
    max_ttl            = 31536000
    compress               = true
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}


