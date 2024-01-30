# Start by creating the ALB that attaches to the
# relevant public subnets
resource "aws_alb" "main" {
  name            = "training-room"
  subnets         = var.aws_subnet_publics.*.id
  security_groups = [aws_security_group.alb.id]

  enable_deletion_protection = true
  xff_header_processing_mode = "preserve"
}

resource "aws_alb_target_group" "http" {
  vpc_id      = var.aws_vpc_main.id

  name        = "training-room"
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

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.main.id
  port              = var.http_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.http.id

#     type = "fixed-response"

#     fixed_response {
#       content_type = "text/plain"
#       message_body = ""
#       status_code  = 429 # We use a 429 as this is exclusively to block bots
#     }
  }
  lifecycle {
    create_before_destroy = true
  }
}

# resource "aws_alb_listener_rule" "main" {
#   listener_arn = aws_alb_listener.http.arn
#   priority     = 95
#   action {
#     type             = "forward"
#     target_group_arn = aws_alb_target_group.http.id
#   }

#   condition {
#     host_header {
#       values = [
#         "llmtrainingroom.com"
#       ]
#     }
#   }
# }
