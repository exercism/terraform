# ###
# Set up the cluster
# ###
locals {
  api_container_definitions = templatefile("./webservers/ecs_task_definition_puma.json.tpl", {
    nginx_image                  = "${aws_ecr_repository.nginx.repository_url}:latest"
    rails_image                  = "${aws_ecr_repository.rails.repository_url}:latest"
    http_port                    = var.http_port
    websockets_port              = var.websockets_port
    region                       = var.region
    puma_log_group_name          = aws_cloudwatch_log_group.puma.name
    nginx_log_group_name         = aws_cloudwatch_log_group.nginx.name
    log_group_prefix             = "api"
    efs_cache_mount_point  = var.efs_cache_mount_point
    efs_repositories_mount_point = var.efs_repositories_mount_point
    efs_tooling_jobs_mount_point = var.efs_tooling_jobs_mount_point
  })
}
resource "aws_ecs_task_definition" "api" {
  family                   = "api"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.service_api_cpu
  memory                   = var.service_api_memory
  container_definitions    = local.api_container_definitions
  execution_role_arn       = var.aws_iam_role_ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs.arn
  tags                     = {}

  volume {
    name = "efs-repositories"
    efs_volume_configuration {
      file_system_id = var.aws_efs_file_system_repositories.id
    }
  }

  volume {
    name = "efs-cache"
    efs_volume_configuration {
      file_system_id = var.aws_efs_file_system_cache.id
    }
  }
  volume {
    name = "efs-tooling-jobs"
    efs_volume_configuration {
      file_system_id = var.aws_efs_file_system_tooling_jobs.id
    }
  }
}

resource "aws_ecs_service" "api" {
  name             = "api"
  cluster          = aws_ecs_cluster.webservers.id
  task_definition  = aws_ecs_task_definition.api.arn
  desired_count    = var.service_api_count
  launch_type      = "FARGATE"
  platform_version = "1.4.0"

  # Pause for 10mins to let migrations run
  health_check_grace_period_seconds = 600

  network_configuration {
    security_groups = [
      aws_security_group.ecs.id,
      var.aws_security_group_efs_repositories_access.id,
      var.aws_security_group_efs_cache_access.id,
      var.aws_security_group_efs_tooling_jobs_access.id
    ]
    subnets = var.aws_subnet_publics.*.id

    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.api.id
    container_name   = "nginx"
    container_port   = var.http_port
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.spi.id
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

resource "aws_appautoscaling_target" "api_desired_count" {
  max_capacity       = 12
  min_capacity       = 4
  resource_id        = "service/webservers/api"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "api_cpu" {
  name               = "CPU Tracking"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "service/webservers/api"
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

resource "aws_appautoscaling_policy" "api_memory" {
  name               = "Memory Tracking"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "service/webservers/api"
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