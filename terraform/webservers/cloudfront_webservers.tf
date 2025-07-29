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
  origin_id_alb             = "ALB-${aws_alb.webservers.name}"
  origin_id_plausible       = "plausible.io"
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
    "www.exercism.org",
    "bootcamp.exercism.org"
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
    allowed_methods          = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods           = ["GET", "HEAD"]
    target_origin_id         = local.origin_id_alb
    cache_policy_id          = aws_cloudfront_cache_policy.main.id
    origin_request_policy_id = "33f36d7e-f396-46d9-90e0-52428a34d9dc"
    compress                 = true

    viewer_protocol_policy = "redirect-to-https"

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
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
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
    compress               = false
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
    compress               = false
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

  ordered_cache_behavior {
    path_pattern    = "/site.webmanifest"
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true

    viewer_protocol_policy = "redirect-to-https"
    target_origin_id       = local.origin_id_alb

    cache_policy_id = data.aws_cloudfront_cache_policy.CachingOptimized.id
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

resource "aws_cloudfront_cache_policy" "main" {
  name = "WebserversCachePolicy"

  default_ttl = 300
  max_ttl     = 3600
  min_ttl     = 0

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "whitelist"
      cookies {
        items = ["_exercism_user_id"]
      }
    }
    headers_config {
      header_behavior = "whitelist"
      headers {
        items = ["Host", "Turbo-Frame"]
      }
    }
    query_strings_config {
      query_string_behavior = "none"
    }

    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true
  }
}

resource "aws_cloudfront_function" "set_x_if_none_match" {
  name    = "set-x-if-none-match"
  runtime = "cloudfront-js-2.0"

  comment = "Copies If-None-Match to X-If-None-Match so origin can access it when cookies are forwarded"

  publish = true

  code = <<EOF
function handler(event) {
  var request = event.request;
  var headers = request.headers;

  if (headers['if-none-match']) {
    headers['x-if-none-match'] = headers['if-none-match'];
  }

  return request;
}
EOF
}