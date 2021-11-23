# ###
# Set up the cluster
# ###
data "template_file" "anycable" {
  template = file("./webservers/ecs_task_definition_anycable.json.tpl")

  vars = {
    nginx_image        = "${aws_ecr_repository.nginx.repository_url}:latest"
    rails_image        = "${aws_ecr_repository.rails.repository_url}:latest"
    anycable_go_image  = "${var.aws_ecr_repository_anycable_go_pro.repository_url}:latest"
    anycable_redis_url = "redis://${var.aws_redis_url_anycable}:6379/1"
    http_port          = var.http_port
    region             = var.region
    log_group_name     = aws_cloudwatch_log_group.webservers.name
    log_group_prefix     = "anycable"
  }
}
resource "aws_ecs_task_definition" "anycable" {
  family                   = "anycable"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.service_anycable_cpu
  memory                   = var.service_anycable_memory
  container_definitions    = data.template_file.anycable.rendered
  execution_role_arn       = var.aws_iam_role_ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs.arn
  tags                     = {}
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

    # TODO: Can this be false?
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
    # ignore_changes = [
    #   task_definition
    # ]
  }
}

