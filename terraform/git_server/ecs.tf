
# ###
# Set up the cluster
# ###
resource "aws_ecs_cluster" "git_servers" {
  name = "git_servers"
}
data "template_file" "git_servers" {
  template = file("./git_server/ecs_task_definition.json.tpl")

  vars = {
    application_image = "${aws_ecr_repository.application.repository_url}:latest"
    nginx_image       = "${aws_ecr_repository.nginx.repository_url}:latest"
    http_port         = var.http_port
    region            = var.region
    log_group_name    = aws_cloudwatch_log_group.git_servers.name
  }
}
resource "aws_ecs_task_definition" "git_servers" {
  family                   = "git_servers"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  container_definitions    = data.template_file.git_servers.rendered
  execution_role_arn       = var.aws_iam_role_ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs.arn
  tags                     = {}

  volume {
    name = "efs-repositories"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.repositories.id
    }
  }
}
resource "aws_ecs_service" "git_servers" {
  name             = "git_servers"
  cluster          = aws_ecs_cluster.git_servers.id
  task_definition  = aws_ecs_task_definition.git_servers.arn
  desired_count    = var.container_count
  platform_version = "1.4.0"
  launch_type      = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs.id]
    subnets          = var.aws_subnet_publics.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.http.id
    container_name   = "nginx"
    container_port   = var.http_port
  }

  depends_on = [
    aws_alb_listener.http
  ]
}

