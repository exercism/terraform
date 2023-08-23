resource "aws_alb_listener_rule" "spi" {
  listener_arn = var.aws_alb_listener_internal.arn
  priority     = 90
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.spi.id
  }

  condition {
    path_pattern {
      values = ["/spi/*"]
    }
  }
}

resource "aws_alb_target_group" "spi" {
  vpc_id      = var.aws_vpc_main.id

  name        = "webservers-spi"
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

