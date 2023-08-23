# ###
# Set up the cluster
# ###
locals {
  website_container_definitions = templatefile("./webservers/ecs_task_definition_puma.json.tpl", {
    nginx_image                  = "${aws_ecr_repository.nginx.repository_url}:latest"
    rails_image                  = "${aws_ecr_repository.rails.repository_url}:latest"
    http_port                    = var.http_port
    websockets_port              = var.websockets_port
    region                       = var.region
    puma_log_group_name          = aws_cloudwatch_log_group.puma.name
    nginx_log_group_name         = aws_cloudwatch_log_group.nginx.name
    log_group_prefix             = "website"
    efs_submissions_mount_point  = var.efs_submissions_mount_point
    efs_repositories_mount_point = var.efs_repositories_mount_point
  })
}
resource "aws_ecs_task_definition" "website" {
  family                   = "website"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.service_website_cpu
  memory                   = var.service_website_memory
  container_definitions    = local.website_container_definitions
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
    name = "efs-submissions"
    efs_volume_configuration {
      file_system_id = var.aws_efs_file_system_submissions.id
    }
  }
}

resource "aws_ecs_service" "website" {
  name             = "website"
  cluster          = aws_ecs_cluster.webservers.id
  task_definition  = aws_ecs_task_definition.website.arn
  desired_count    = var.service_website_count
  launch_type      = "FARGATE"
  platform_version = "1.4.0"

  # Pause for 10mins to let migrations run
  health_check_grace_period_seconds = 600

  network_configuration {
    security_groups = [
      aws_security_group.ecs.id,
      var.aws_security_group_efs_repositories_access.id,
      var.aws_security_group_efs_submissions_access.id
    ]
    subnets = var.aws_subnet_publics.*.id

    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.website.id
    container_name   = "nginx"
    container_port   = var.http_port
  }

  depends_on = [
    aws_alb_listener.http
  ]

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      task_definition
    ]
  }
}

