locals {
  webservers_origin_id = "webservers"
  s3_assets_origin_id  = "assets"
  s3_images_origin_id  = "images"
}

variable images_ordered_cache_behavior_paths {
  default = ["images", "exercises", "key-features", "meta", "placeholders", "tracks"]
}

resource "aws_cloudfront_origin_access_identity" "assets" {
  comment = "Original Access Identity for assets"
}

resource "aws_cloudfront_distribution" "assets" {
  enabled         = true
  is_ipv6_enabled = true
  http_version    = "http2and3"
  aliases         = ["assets.exercism.org"]

  origin {
    domain_name = var.webservers_alb_hostname
    origin_id   = local.webservers_origin_id

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2", "SSLv3"]
    }
  }

  origin {
    domain_name = aws_s3_bucket.assets.bucket_regional_domain_name
    origin_id   = local.s3_assets_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.assets.cloudfront_access_identity_path
    }
  }

  origin {
    domain_name = aws_s3_bucket.icons.bucket_regional_domain_name
    origin_id   = local.s3_images_origin_id
  }


  ordered_cache_behavior {
    path_pattern     = "/rails/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.webservers_origin_id

    forwarded_values {
      query_string = true

      cookies{
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    viewer_protocol_policy = "allow-all"
 }


  dynamic "ordered_cache_behavior" {
    for_each = var.images_ordered_cache_behavior_paths

    content {
      path_pattern     = "/${ordered_cache_behavior.value}/*"
      allowed_methods  = ["GET", "HEAD", "OPTIONS" ]
      cached_methods   = ["GET", "HEAD"]
      target_origin_id = local.s3_images_origin_id
      cache_policy_id  = "658327ea-f89d-4fab-a63d-7e88639e58f6"

      viewer_protocol_policy = "redirect-to-https"
      compress               = true
    }
  }

   ordered_cache_behavior {
     path_pattern           = "/avatars/*"
     allowed_methods        = [ "GET", "HEAD" ]
     cached_methods         = [ "GET", "HEAD" ]
     target_origin_id       = "webservers"
     cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
     viewer_protocol_policy = "redirect-to-https"
      compress               = true
  }

  default_cache_behavior {
    allowed_methods            = ["GET", "HEAD", "OPTIONS"]
    cached_methods             = ["GET", "HEAD"]
    target_origin_id           = local.s3_assets_origin_id
    response_headers_policy_id = "5cc3b908-e619-4b99-88e5-2cf7f45965bd"

    forwarded_values {
      query_string = false
      # headers      = ["Origin", "Access-Control-Request-Headers", "Access-Control-Request-Method"]

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 31536000
    default_ttl            = 31536001
    max_ttl                = 31536002
    compress               = true
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = "arn:aws:acm:us-east-1:681735686245:certificate/80adfa11-56c7-48d8-bb54-e9c646430fe2"
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }
}


