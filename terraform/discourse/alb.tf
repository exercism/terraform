# Start by creating the ALB that attaches to the
# relevant public subnets
resource "aws_alb" "discourse" {
  name            = "discourse"
  subnets         = var.aws_subnet_publics.*.id
  security_groups = [aws_security_group.alb.id]

  enable_deletion_protection = true
}

resource "aws_alb_target_group" "discourse" {
  name     = "discourse"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.aws_vpc_main.id
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

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_alb.discourse.id
  port              = 443
  protocol          = "HTTPS"
  certificate_arn = "arn:aws:acm:eu-west-2:681735686245:certificate/31fa3203-2957-4030-8390-7e149e8aa1c3"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.discourse.arn
    forward {
      stickiness {
        duration = 3600
        enabled = false
      }
      target_group {
        arn = aws_alb_target_group.discourse.arn
        weight = 1
      }
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}
