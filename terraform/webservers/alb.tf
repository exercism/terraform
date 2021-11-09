# Start by creating the ALB that attaches to the
# relevant public subnets
resource "aws_alb" "webservers" {
  name            = "webservers"
  subnets         = var.aws_subnet_publics.*.id
  security_groups = [aws_security_group.alb.id]

  enable_deletion_protection = true
}

# Create a target group for the http webservers
resource "aws_alb_target_group" "http" {
  name        = "webservers-http"
  port        = var.http_port
  protocol    = "HTTP"
  vpc_id      = var.aws_vpc_main.id
  target_type = "ip"

  deregistration_delay = 10

  health_check {
    path = "/health-check"

    healthy_threshold   = 2
    unhealthy_threshold = 10
    interval            = 5
    timeout             = 4
  }
}

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
      status_code  = 429 # We use a 429 as this is exclusivily to block bots
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_listener_rule" "http" {
  listener_arn = aws_alb_listener.http.arn
  priority = 100
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.http.id
  }

  condition {
    host_header {
      values = [
        var.website_host
      ]
    }
  }
}

resource "aws_alb_listener_rule" "api" {
  listener_arn = aws_alb_listener.http.arn
  priority = 102
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.http.id
  }

  condition {
    host_header {
      values = [
        "api.${var.website_host}",
        "api.exercism.io"
      ]
    }
  }
}

resource "aws_alb_listener_rule" "aliases" {
  listener_arn = aws_alb_listener.http.arn
  priority = 103
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.http.id
  }

  condition {
    host_header {
      values = [
        aws_cloudfront_distribution.webservers.domain_name,
        "www.exercism.org",
        aws_alb.webservers.dns_name
      ]
    }
  }
}

resource "aws_alb_listener_rule" "legacy" {
  listener_arn = aws_alb_listener.http.arn
  priority = 104
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.http.id
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
