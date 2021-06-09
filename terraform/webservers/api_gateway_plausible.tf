resource "aws_api_gateway_rest_api" "plausible" {
  name = "plausible"
}

resource "aws_api_gateway_resource" "plausible" {
  path_part   = "{proxy+}"
  parent_id   = aws_api_gateway_rest_api.plausible.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.plausible.id
}

resource "aws_api_gateway_method" "any" {
  rest_api_id        = aws_api_gateway_rest_api.plausible.id
  resource_id        = aws_api_gateway_resource.plausible.id
  http_method        = "ANY"
  authorization      = "NONE"
  request_parameters            = {"method.request.path.proxy" = true}
}

resource "aws_api_gateway_method_settings" "plausible" {
  rest_api_id = aws_api_gateway_rest_api.plausible.id
  stage_name  = aws_api_gateway_deployment.plausible.stage_name
  method_path = "*/*"

  settings {
    # Enable CloudWatch logging and metrics
    metrics_enabled    = true
    data_trace_enabled = true
    logging_level      = "INFO"

    # Limit the rate of calls to prevent abuse and unwanted charges
    throttling_rate_limit  = 100
    throttling_burst_limit = 50
  }
}

resource "aws_api_gateway_integration" "plausible" {
  rest_api_id             = aws_api_gateway_rest_api.plausible.id
  resource_id             = aws_api_gateway_resource.plausible.id
  http_method             = aws_api_gateway_method.any.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "https://plausible.io/{proxy}"
  passthrough_behavior    = "WHEN_NO_MATCH"
   request_parameters = { "integration.request.path.proxy" = "method.request.path.proxy" }
  
}

resource "aws_api_gateway_deployment" "plausible" {
  depends_on = [
    aws_api_gateway_integration.plausible,
  ]

  rest_api_id = aws_api_gateway_rest_api.plausible.id
  stage_name  = "production"
}


resource "aws_acm_certificate" "plausible" {
  domain_name       = "plausible.${var.website_host}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "plausible-certificate" {
  for_each = {
    for dvo in aws_acm_certificate.plausible.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.route53_zone_main.zone_id
}

resource "aws_acm_certificate_validation" "plausible" {
  certificate_arn         = aws_acm_certificate.plausible.arn
  validation_record_fqdns = [for record in aws_route53_record.plausible-certificate : record.fqdn]
}

resource "aws_api_gateway_domain_name" "plausible" {
  certificate_arn = aws_acm_certificate_validation.plausible.certificate_arn
  domain_name     = "plausible.${var.website_host}"
}

resource "aws_route53_record" "plausible" {
  name    = aws_api_gateway_domain_name.plausible.domain_name
  type    = "A"
  zone_id = var.route53_zone_main.id

  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.plausible.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.plausible.cloudfront_zone_id
  }
}

