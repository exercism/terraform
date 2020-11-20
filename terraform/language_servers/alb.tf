resource "aws_alb" "language_servers" {
  name            = "language-servers"
  subnets         = var.aws_subnet_publics.*.id
  security_groups = [aws_security_group.alb.id]
  # TODO - Turn this on in production
  enable_deletion_protection = false
}

# Create a target group for the websockets
resource "aws_alb_target_group" "websockets" {
  name        = "language-servers-websockets"
  port        = var.websockets_port
  protocol    = "HTTP"
  vpc_id      = var.aws_vpc_main.id
  target_type = "ip"
  health_check {
    path = "/health"
    # TODO: These are awful values for production
    # but work well for development.
    unhealthy_threshold = 10
    interval            = 300
  }
}
# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "websockets" {
  load_balancer_arn = aws_alb.language_servers.id
  port              = var.websockets_port
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_alb_target_group.websockets.id
    type             = "forward"
  }
}
