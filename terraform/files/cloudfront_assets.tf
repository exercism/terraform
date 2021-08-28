locals {
  s3_assets_origin_id = "assets"
}

resource "aws_cloudfront_origin_access_identity" "assets" {
  comment = "Original Access Identity for assets"
}

resource "aws_cloudfront_distribution" "assets" {
  enabled         = true
  is_ipv6_enabled = true

  origin {
    domain_name = aws_s3_bucket.assets.bucket_regional_domain_name
    origin_id   = local.s3_assets_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.assets.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_assets_origin_id

    forwarded_values {
      query_string = false
      headers      = ["Origin", "Access-Control-Request-Headers", "Access-Control-Request-Method"]

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    default_ttl            = 31536000
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

