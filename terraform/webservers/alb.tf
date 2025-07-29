# Start by creating the ALB that attaches to the
# relevant public subnets
resource "aws_alb" "webservers" {
  name            = "webservers"
  subnets         = var.aws_subnet_publics.*.id
  security_groups = [aws_security_group.alb.id]

  enable_deletion_protection = true
  xff_header_processing_mode = "preserve"
}

resource "aws_alb_target_group" "website" {
  vpc_id = var.aws_vpc_main.id

  name        = "webservers-website"
  port        = var.http_port
  protocol    = "HTTP"
  target_type = "ip"

  deregistration_delay = 10

  health_check {
    path = "/health-check"

    healthy_threshold   = 2
    unhealthy_threshold = 10
    interval            = 5
    timeout             = 2
  }
}

resource "aws_alb_target_group" "api" {
  vpc_id = var.aws_vpc_main.id

  name        = "webservers-api"
  port        = var.http_port
  protocol    = "HTTP"
  target_type = "ip"

  deregistration_delay = 10

  health_check {
    path = "/health-check"

    healthy_threshold   = 2
    unhealthy_threshold = 10
    interval            = 5
    timeout             = 2
  }
}

resource "aws_alb_target_group" "anycable" {
  vpc_id = var.aws_vpc_main.id

  name        = "webservers-anycable"
  port        = var.http_port
  protocol    = "HTTP"
  target_type = "ip"

  deregistration_delay = 10

  health_check {
    path = "/cable/health"

    healthy_threshold   = 2
    unhealthy_threshold = 10
    interval            = 5
    timeout             = 2
  }
}

/********************/
/*** HTTP Listener **/
/********************/

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.webservers.id
  port              = var.http_port
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = ""
      status_code  = 429 # We use a 429 as this is exclusively to block bots
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

# Block any SPI access
resource "aws_alb_listener_rule" "block_spi" {
  listener_arn = aws_alb_listener.http.arn
  priority     = 90

  condition {
    path_pattern {
      values = ["/spi", "/spi/*"]
    }
  }

  action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = ""
      status_code  = 429 # We use a 429 as this is exclusively to block bots
    }
  }
}

resource "aws_alb_listener_rule" "anycable" {
  listener_arn = aws_alb_listener.http.arn
  priority     = 91

  condition {
    path_pattern {
      values = ["/cable", "/cable/*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.anycable.id
  }
}

# TODO: Rename the TF
resource "aws_alb_listener_rule" "api_subdomain" {
  listener_arn = aws_alb_listener.http.arn
  priority     = 92

  condition {
    host_header {
      values = [
        "api.${var.website_host}",
        "api.exercism.io"
      ]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.api.id
  }
}

# TODO: Rename the TF
resource "aws_alb_listener_rule" "api_subdirectory" {
  listener_arn = aws_alb_listener.http.arn
  priority     = 93
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.api.id
  }

  condition {
    path_pattern {
      values = ["/api", "/api/*"]
    }
  }

  condition {
    host_header {
      values = [
        var.website_host,
        aws_alb.webservers.dns_name
      ]
    }
  }
}

resource "aws_alb_listener_rule" "website" {
  listener_arn = aws_alb_listener.http.arn
  priority     = 95
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.website.id
  }

  condition {
    host_header {
      values = [
        var.website_host,
        aws_alb.webservers.dns_name
      ]
    }
  }
}

resource "aws_alb_listener_rule" "aliases" {
  listener_arn = aws_alb_listener.http.arn
  priority     = 103
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.website.id
  }

  condition {
    host_header {
      values = [
        aws_cloudfront_distribution.webservers.domain_name,
        "www.exercism.org",
      ]
    }
  }
}

resource "aws_alb_listener_rule" "legacy" {
  listener_arn = aws_alb_listener.http.arn
  priority     = 104
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.website.id
  }

  condition {
    host_header {
      values = [
        "exercism.io",
        "www.exercism.io",
        "exercism.net",
        "exercism.lol",
        "exercism.com"
      ]
    }
  }
}

resource "aws_alb_listener_rule" "bootcamp" {
  listener_arn = aws_alb_listener.http.arn
  priority     = 105
  tags = { 
    "Name" = "Bootcamp" 
  }
  action {
    type             = "forward"

    forward {
      target_group {
        arn = aws_alb_target_group.website.id
      }
      stickiness {
        duration = 3600
      }
    }
  }

  condition {
    host_header {
      values = [ "bootcamp.exercism.org" ]
    }
  }
}
 
/*********************/
/*** HTTPS Listener **/
/*********************/

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_alb.webservers.id
  port              = 443
  protocol          = "HTTPS"
  certificate_arn = "arn:aws:acm:eu-west-2:681735686245:certificate/31fa3203-2957-4030-8390-7e149e8aa1c3"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = ""
      status_code  = 429 # We use a 429 as this is exclusively to block bots
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

# Block any SPI access
resource "aws_alb_listener_rule" "https_block_spi" {
  listener_arn = aws_alb_listener.https.arn
  priority     = 90

  condition {
    path_pattern {
      values = ["/spi", "/spi/*"]
    }
  }

  action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = ""
      status_code  = 429 # We use a 429 as this is exclusively to block bots
    }
  }
}

resource "aws_alb_listener_rule" "https_anycable" {
  listener_arn = aws_alb_listener.https.arn
  priority     = 91

  condition {
    path_pattern {
      values = ["/cable", "/cable/*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.anycable.id
  }
}

# TODO: Rename the TF
resource "aws_alb_listener_rule" "https_api_subdomain" {
  listener_arn = aws_alb_listener.https.arn
  priority     = 92

  condition {
    host_header {
      values = [
        "api.${var.website_host}",
        "api.exercism.io"
      ]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.api.id
  }
}

# TODO: Rename the TF
resource "aws_alb_listener_rule" "https_api_subdirectory" {
  listener_arn = aws_alb_listener.https.arn
  priority     = 93
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.api.id
  }

  condition {
    path_pattern {
      values = ["/api", "/api/*"]
    }
  }

  condition {
    host_header {
      values = [
        var.website_host,
        aws_alb.webservers.dns_name
      ]
    }
  }
}


resource "aws_alb_listener_rule" "https_website" {
  listener_arn = aws_alb_listener.https.arn
  priority     = 95
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.website.id
  }

  condition {
    host_header {
      values = [
        var.website_host,
        aws_alb.webservers.dns_name
      ]
    }
  }
}

resource "aws_alb_listener_rule" "https_aliases" {
  listener_arn = aws_alb_listener.https.arn
  priority     = 103
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.website.id
  }

  condition {
    host_header {
      values = [
        aws_cloudfront_distribution.webservers.domain_name,
        "www.exercism.org",
      ]
    }
  }
}

resource "aws_alb_listener_rule" "https_legacy" {
  listener_arn = aws_alb_listener.https.arn
  priority     = 104
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.website.id
  }

  condition {
    host_header {
      values = [
        "exercism.io",
        "www.exercism.io",
        "exercism.net",
        "bootcamp.exercism.org",
        "exercism.com"
      ]
    }
  }
}