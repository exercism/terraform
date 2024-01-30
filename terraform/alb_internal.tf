locals {
  subdomain = "internal.exercism.org"
}

data "aws_route53_zone" "main" {
  name = "exercism.org"
}

resource "aws_alb" "internal" {
  name            = "internal"
  internal        = true
  subnets         = aws_subnet.publics.*.id
  security_groups = [aws_security_group.internal_alb.id]

  enable_deletion_protection = true
}

resource "aws_alb_listener" "internal" {
  load_balancer_arn = aws_alb.internal.id
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate_validation.internal_alb.certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Route not found at ALB level"
      status_code  = 404
    }
  }
}

resource "aws_security_group" "internal_alb" {
  name        = "internal_alb"
  description = "controls access to the internal ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = [aws_vpc.main.cidr_block]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port   = 0
    ipv6_cidr_blocks = [
      "::/0",
    ]
    protocol = "-1"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "internal_alb" {
  domain_name       = local.subdomain
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "internal_alb_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.internal_alb.domain_validation_options : dvo.domain_name => {
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
  zone_id         = data.aws_route53_zone.main.zone_id
}

resource "aws_acm_certificate_validation" "internal_alb" {
  certificate_arn         = aws_acm_certificate.internal_alb.arn
  validation_record_fqdns = [for record in aws_route53_record.internal_alb_cert_validation : record.fqdn]
}

resource "aws_route53_record" "main" {
  zone_id = data.aws_route53_zone.main.zone_id
  type    = "CNAME"
  name    = local.subdomain
  records = [aws_alb.internal.dns_name]
  ttl     = "30"
}
