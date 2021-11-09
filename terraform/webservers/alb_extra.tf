# Create a target group for the http webservers
resource "aws_alb" "webservers_split" {
  name            = "webservers-split"
  subnets         = var.aws_subnet_publics.*.id
  security_groups = [aws_security_group.alb.id]

  enable_deletion_protection = true
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "webservers_split" {
  load_balancer_arn = aws_alb.webservers_split.id
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

resource "aws_alb_target_group" "puma" {
  name        = "webservers-puma"
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

# resource "aws_alb_target_group" "anycable" {
#   name        = "webservers-anycable"
#   port        = var.service_anycable_port
#   protocol    = "HTTP"
#   vpc_id      = var.aws_vpc_main.id
#   target_type = "ip"

#   deregistration_delay = 10

#   health_check {
#     path = "/health-check"

#     healthy_threshold   = 2
#     unhealthy_threshold = 10
#     interval            = 5
#     timeout             = 4
#   }
# }

# resource "aws_alb_listener_rule" "anycable" {
#   listener_arn = aws_alb_listener.http.arn
#   priority     = 200
#   action {
#     type             = "forward"
#     target_group_arn = aws_alb_target_group.anycable.id
#   }

#   condition {
#     path_pattern {
#       values = ["/cable"]
#     }
#   }

#   condition {
#     host_header {
#       values = [aws_alb.webservers.dns_name]
#     }
#   }
# }

resource "aws_alb_listener_rule" "puma" {
  listener_arn = aws_alb_listener.webservers_split.arn
  priority     = 201
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.puma.id
  }

  depends_on = [
    aws_alb_target_group.puma
  ]


  condition {
    host_header {
      values = [aws_alb.webservers_split.dns_name]
    }
  }
}

