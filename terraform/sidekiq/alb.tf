# Start by creating the ALB that attaches to the 
# relevant public subnets
resource "aws_alb" "sidekiq" {
  name            = "sidekiq"
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
  name        = "sidekiqs-ecs-http"
  port        = var.monitor_port
  protocol    = "HTTP"
  vpc_id      = var.aws_vpc_main.id
  target_type = "ip"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    interval            = 10
  }
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.sidekiq.id
  port              = var.monitor_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.http.id
    type             = "forward"
  }
}
