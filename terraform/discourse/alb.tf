# Start by creating the ALB that attaches to the
# relevant public subnets
resource "aws_alb" "discourse" {
  name            = "discourse"
  subnets         = var.aws_subnet_publics.*.id
  security_groups = [aws_security_group.alb.id]

  enable_deletion_protection = true
}

resource "aws_alb_target_group" "discourse" {
  name        = "discourse"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.aws_vpc_main.id
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "discourse" {
  load_balancer_arn = aws_alb.discourse.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.discourse.id
  }
  lifecycle {
    create_before_destroy = true
  }
}
