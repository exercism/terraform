# Start by creating the ALB that attaches to the 
# relevant public subnets
resource "aws_alb" "webservers" {
  name            = "webservers-ecs"
  subnets         = aws_subnet.publics.*.id
  security_groups = ["${aws_security_group.alb.id}"]
}

# Create a target group for the webservers
resource "aws_alb_target_group" "webservers" {
  name        = "webservers-ecs"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "webservers" {
  load_balancer_arn = aws_alb.webservers.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.webservers.id
    type             = "forward"
  }
}
