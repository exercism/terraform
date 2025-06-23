# ###
# Set up the cluster
# ###
locals {
  anycable_container_definitions = templatefile("./webservers/ecs_task_definition_anycable.json.tpl", {
    nginx_image        = "${aws_ecr_repository.nginx.repository_url}:latest"
    rails_image        = "${aws_ecr_repository.rails.repository_url}:latest"
    anycable_go_image  = "${var.aws_ecr_repository_anycable_go_pro.repository_url}:latest"
    anycable_redis_url = "redis://${var.aws_redis_url_anycable}:6379/1"
    http_port          = var.http_port
    region             = var.region
    log_group_name     = aws_cloudwatch_log_group.webservers.name
    log_group_prefix     = "anycable"
  })
}
resource "aws_ecs_task_definition" "anycable" {
  family                   = "anycable"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.service_anycable_cpu
  memory                   = var.service_anycable_memory
  container_definitions    = local.anycable_container_definitions
  execution_role_arn       = var.aws_iam_role_ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs.arn
  tags                     = {}
  skip_destroy = true
}

resource "aws_ecs_service" "anycable" {
  name             = "anycable"
  cluster          = aws_ecs_cluster.webservers.id
  task_definition  = aws_ecs_task_definition.anycable.arn
  desired_count    = var.service_anycable_count
  launch_type      = "FARGATE"
  platform_version = "1.4.0"

  # Pause for 10mins to let migrations run
  health_check_grace_period_seconds = 600

  network_configuration {
    security_groups = [
      aws_security_group.ecs.id,
    ]
    subnets = var.aws_subnet_publics.*.id

    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.anycable.id
    container_name   = "nginx"
    container_port   = var.http_port
  }

  depends_on = [
    aws_alb_listener.http
  ]

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      task_definition,
      desired_count
    ]
  }
}

resource "aws_appautoscaling_target" "anycable_desired_count" {
  max_capacity       = 12
  min_capacity       = 2
  resource_id        = "service/webservers/anycable"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "anycable_cpu" {
  name               = "CPU Tracking"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "service/webservers/anycable"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  target_tracking_scaling_policy_configuration {
    target_value       = 50.0

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    scale_in_cooldown  = 120
    scale_out_cooldown = 120
    disable_scale_in   = false
  }
}

resource "aws_appautoscaling_policy" "anycable_memory" {
  name               = "Memory Tracking"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "service/webservers/anycable"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  target_tracking_scaling_policy_configuration {
    target_value       = 50.0

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    scale_in_cooldown  = 120
    scale_out_cooldown = 120
    disable_scale_in   = false
  }
}