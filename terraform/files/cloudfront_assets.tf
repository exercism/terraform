data "aws_cloudfront_origin_request_policy" "AllViewerExceptHostHeader" {
  name = "Managed-AllViewerExceptHostHeader"
}

locals {
  webservers_origin_id = "webservers"
  s3_assets_origin_id  = "assets"
  s3_images_origin_id  = "images"
  origin_id_image_generator = "image-generator"
}

variable "images_ordered_cache_behavior_paths" {
  default = ["images", "exercises", "key-features", "meta", "placeholders", "tracks"]
}

resource "aws_cloudfront_origin_access_identity" "assets" {
  comment = "Original Access Identity for assets"
}
data "aws_cloudfront_cache_policy" "CachingOptimized" {
  name = "Managed-CachingOptimized"
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

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    viewer_protocol_policy = "allow-all"
  }

  ####################
  # Generated images #
  ####################
  origin {
    domain_name = "jndbzzcsm7f5srkgo7ktdsapnu0pjsbr.lambda-url.eu-west-2.on.aws"
    origin_id   = local.origin_id_image_generator

    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = tolist([
      "/tracks/*/exercises/*/solutions/*.jpg",
      "/profiles/*.jpg"
    ])
    content {
      path_pattern           = ordered_cache_behavior.value
      allowed_methods        = ["GET", "HEAD"]
      cached_methods         = ["GET", "HEAD"]
      compress               = true
      viewer_protocol_policy = "redirect-to-https"
      target_origin_id       = local.origin_id_image_generator

      cache_policy_id          = data.aws_cloudfront_cache_policy.CachingOptimized.id
      origin_request_policy_id = data.aws_cloudfront_origin_request_policy.AllViewerExceptHostHeader.id
    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.images_ordered_cache_behavior_paths

    content {
      path_pattern     = "/${ordered_cache_behavior.value}/*"
      allowed_methods  = ["GET", "HEAD", "OPTIONS"]
      cached_methods   = ["GET", "HEAD"]
      target_origin_id = local.s3_images_origin_id
      cache_policy_id  = data.aws_cloudfront_cache_policy.CachingOptimized.id

      viewer_protocol_policy = "redirect-to-https"
      compress               = true
    }
  }

  ordered_cache_behavior {
    path_pattern           = "/avatars/*"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "webservers"
    cache_policy_id        = data.aws_cloudfront_cache_policy.CachingOptimized.id
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
  }

  default_cache_behavior {
    allowed_methods            = ["GET", "HEAD", "OPTIONS"]
    cached_methods             = ["GET", "HEAD"]
    target_origin_id           = local.s3_assets_origin_id
    response_headers_policy_id = "5cc3b908-e619-4b99-88e5-2cf7f45965bd" // CORS-With-Preflight

    /*forwarded_values {
      query_string = false
      # headers      = ["Origin", "Access-Control-Request-Headers", "Access-Control-Request-Method"]

      cookies {
        forward = "none"
      }
    }*/

    viewer_protocol_policy = "redirect-to-https"
    cache_policy_id        = "ccbe5100-fe97-4484-8111-4467cea80fd3"
    compress               = true
  }
  ordered_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
      "OPTIONS",
    ]
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = true
    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    path_pattern           = "/bootcamp/*"
    smooth_streaming       = false
    target_origin_id       = "images"
    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"
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