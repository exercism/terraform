# Start by creating the ALB that attaches to the 
# relevant public subnets
resource "aws_alb" "webservers" {
  name            = "webservers-ecs"
  subnets         = var.aws_subnet_publics.*.id
  security_groups = ["${aws_security_group.webservers_alb.id}"]

  #access_logs {
  #  bucket  = aws_s3_bucket.ops_bucket.bucket
  #  prefix  = "alb"
  #  enabled = true
  #}

  # TODO - Turn this on in production
  enable_deletion_protection = false
}

# Create a target group for the http webservers
resource "aws_alb_target_group" "webservers_http" {
  name        = "webservers-ecs-http"
  port        = var.http_port
  protocol    = "HTTP"
  vpc_id      = var.aws_vpc_main.id
  target_type = "ip"

  health_check {
    # TODO: These are awful values for production
    # but work well for development.
    unhealthy_threshold = 10
    interval            = 300
  }
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "webservers_http" {
  load_balancer_arn = aws_alb.webservers.id
  port              = var.http_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.webservers_http.id
    type             = "forward"
  }
}

# Create a target group for the websockets
resource "aws_alb_target_group" "webservers_websockets" {
  name        = "webservers-ecs-websockets"
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
resource "aws_alb_listener" "webservers_websockets" {
  load_balancer_arn = aws_alb.webservers.id
  port              = var.websockets_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.webservers_websockets.id
    type             = "forward"
  }
}
