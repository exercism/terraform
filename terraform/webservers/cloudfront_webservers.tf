data "aws_cloudfront_origin_request_policy" "Managed-UserAgentRefererHeaders" {
  name = "Managed-UserAgentRefererHeaders"
}

locals {
  origin_id_alb       = "ALB-${aws_alb.webservers.name}"
  origin_id_plausible = "plausible.io"
}

resource "aws_cloudfront_distribution" "webservers" {
  enabled         = true
  is_ipv6_enabled = true
  # aliases         = [var.website_host]

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
    cloudfront_default_certificate = true
  }

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

