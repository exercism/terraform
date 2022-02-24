# # ###
# # Set up the cluster
# # ###

# resource "aws_alb_listener_rule" "website_staging" {
#   listener_arn = aws_alb_listener.http.arn
#   priority     = 10
#   action {
#     type             = "forward"
#     target_group_arn = aws_alb_target_group.website_staging.id
#   }

#   condition {
#     http_header {
#       http_header_name = "X-Forwarded-For"
#       values           = ["137.220.124.51", "137.220.124.51"]
#     }
#   }
# }

# resource "aws_alb_target_group" "website_staging" {
#   name        = "webservers-website-staging"
#   port        = var.http_port
#   protocol    = "HTTP"
#   vpc_id      = var.aws_vpc_main.id
#   target_type = "ip"

#   deregistration_delay = 10

#   health_check {
#     path = "/health-check"

#     healthy_threshold   = 2
#     unhealthy_threshold = 10
#     interval            = 5
#     timeout             = 2
#   }
# }

# resource "aws_ecs_service" "website_staging" {
#   name             = "website-staging"
#   cluster          = aws_ecs_cluster.webservers.id
#   task_definition  = aws_ecs_task_definition.website.arn
#   desired_count    = 1
#   launch_type      = "FARGATE"
#   platform_version = "1.4.0"

#   # Pause for 10mins to let migrations run
#   health_check_grace_period_seconds = 600

#   network_configuration {
#     security_groups = [
#       aws_security_group.ecs.id,
#       var.aws_security_group_efs_repositories_access.id,
#       var.aws_security_group_efs_submissions_access.id
#     ]
#     subnets = var.aws_subnet_publics.*.id

#     # TODO: Can this be false?
#     assign_public_ip = true
#   }

#   load_balancer {
#     target_group_arn = aws_alb_target_group.website_staging.id
#     container_name   = "nginx"
#     container_port   = var.http_port
#   }

#   depends_on = [
#     aws_alb_listener.http
#   ]

#   lifecycle {
#     create_before_destroy = true
#     ignore_changes = [
#       task_definition
#     ]
#   }
# }


