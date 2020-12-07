# Start by creating the ALB that attaches to the 
# relevant public subnets
resource "aws_alb" "webservers" {
  name            = "webservers"
  subnets         = var.aws_subnet_publics.*.id
  security_groups = [aws_security_group.alb.id]

  #access_logs {
  #  bucket  = aws_s3_bucket.ops_bucket.bucket
  #  prefix  = "alb"
  #  enabled = true
  #}

  # TODO - Turn this on in production
  enable_deletion_protection = false
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

    healthy_threshold   = 1
    unhealthy_threshold = 10
    interval            = 5
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
}

resource "aws_alb_listener_rule" "http" {
  listener_arn = aws_alb_listener.http.arn
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.http.id
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

# Create a target group for the websockets
resource "aws_alb_target_group" "websockets" {
  name        = "webservers-websockets"
  port        = var.websockets_port
  protocol    = "HTTP"
  vpc_id      = var.aws_vpc_main.id
  target_type = "ip"

  deregistration_delay = 10

  health_check {
    path = "/health"

    healthy_threshold   = 1
    unhealthy_threshold = 10
    interval            = 5
  }
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "websockets" {
  load_balancer_arn = aws_alb.webservers.id
  port              = var.websockets_port
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = ""
      status_code  = 429 # We use a 429 as this is exclusivily to block bots
    }
  }
}

resource "aws_alb_listener_rule" "websockets" {
  listener_arn = aws_alb_listener.websockets.arn
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.websockets.id
  }

  condition {
    host_header {
      values = [var.website_host]
    }
  }
}

