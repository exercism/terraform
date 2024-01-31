data "aws_cloudfront_origin_request_policy" "Managed-UserAgentRefererHeaders" {
  name = "Managed-UserAgentRefererHeaders"
}
data "aws_cloudfront_cache_policy" "CachingDisabled" {
  name = "Managed-CachingDisabled"
}
data "aws_cloudfront_cache_policy" "CachingOptimized" {
  name = "Managed-CachingOptimized"
}
data "aws_cloudfront_origin_request_policy" "AllViewerExceptHostHeader" {
  name = "Managed-AllViewerExceptHostHeader"
}

locals {
  origin_id_alb       = "ALB-${aws_alb.webservers.name}"
  origin_id_plausible = "plausible.io"
  origin_id_image_generator = "image-generator"
}

resource "aws_cloudfront_distribution" "webservers" {
  enabled         = true
  is_ipv6_enabled = true

  aliases = [
    var.website_host,
    "api.${var.website_host}",
    "api.exercism.io",
    "exercism.net",
    "exercism.com",
    "exercism.io",
    "www.exercism.io",
    "www.exercism.org"
  ]

  origin {
    domain_name = aws_alb.webservers.dns_name
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

    forwarded_values {
      query_string = true
      headers      = ["*"]

      cookies {
        forward = "all"
      }
    }
    viewer_protocol_policy = "redirect-to-https"
    compress = false

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
    minimum_protocol_version = "TLSv1.2_2021"
  }
  # logging_config {
  #   bucket          = "exercism-v3-logs.s3.amazonaws.com"
  #   include_cookies = false
  #   prefix          = "cloudfront-apex/"
  # }

  #############
  # Plausible #
  #############
  origin {
    domain_name = "plausible.io"
    origin_id   = local.origin_id_plausible

    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  ordered_cache_behavior {
    path_pattern           = "/usage/js/script.js"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress = false
    viewer_protocol_policy = "https-only"
    target_origin_id       = local.origin_id_plausible

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    lambda_function_association {
      event_type   = "origin-request"
      lambda_arn   = aws_lambda_function.plausible.qualified_arn
      include_body = false
    }
  }

  ordered_cache_behavior {
    path_pattern           = "/usage/api/event"
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD"]
    compress = false
    viewer_protocol_policy = "https-only"
    target_origin_id       = local.origin_id_plausible

    forwarded_values {
      query_string = false
      headers      = ["User-Agent", "Referer"]
      cookies {
        forward = "none"
      }
    }

    lambda_function_association {
      event_type   = "origin-request"
      lambda_arn   = aws_lambda_function.plausible.qualified_arn
      include_body = false
    }
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

  ordered_cache_behavior {
    path_pattern           = "/tracks/*/exercises/*/solutions/*.jpg"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress = true
    viewer_protocol_policy = "redirect-to-https"
    target_origin_id       = local.origin_id_image_generator

    cache_policy_id = data.aws_cloudfront_cache_policy.CachingOptimized.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.AllViewerExceptHostHeader.id
  }
  ordered_cache_behavior {
      path_pattern           = "/site.webmanifest"
      allowed_methods        = [ "GET", "HEAD" ]
      cached_methods         = [ "GET", "HEAD" ]
      compress               = true

      viewer_protocol_policy = "redirect-to-https"
      target_origin_id       = local.origin_id_alb

      cache_policy_id        = data.aws_cloudfront_cache_policy.CachingOptimized.id
    }
}

resource "aws_lambda_function" "plausible" {
  provider = aws.global

  filename      = "lambda_functions/plausible/function.zip"
  function_name = "plausible"
  role          = aws_iam_role.lambda.arn
  publish       = true
  runtime       = "nodejs14.x"
  handler       = "index.handler"

  source_code_hash = filebase64sha256("lambda_functions/plausible/function.zip")
}

