

# ###
# Set up the cluster
# ###
resource "aws_ecs_cluster" "webservers" {
  name = "webservers"
}
data "template_file" "webservers" {
  template = file("./webservers/ecs_task_definition.json.tpl")

  vars = {
    nginx_image        = "${aws_ecr_repository.nginx.repository_url}:latest"
    rails_image        = "${aws_ecr_repository.rails.repository_url}:latest"
    anycable_go_image  = "${aws_ecr_repository.anycable_go.repository_url}:latest"
    anycable_redis_url = local.anycable_redis_url
    http_port          = var.http_port
    websockets_port    = var.websockets_port
    region             = var.region
    log_group_name     = aws_cloudwatch_log_group.webservers.name
  }
}
resource "aws_ecs_task_definition" "webservers" {
  family                   = "webservers"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  container_definitions    = data.template_file.webservers.rendered
  execution_role_arn       = var.aws_iam_role_ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs.arn
  tags                     = {}
}
resource "aws_ecs_service" "webservers" {
  name            = "webservers"
  cluster         = aws_ecs_cluster.webservers.id
  task_definition = aws_ecs_task_definition.webservers.arn
  desired_count   = var.container_count
  launch_type     = "FARGATE"

  # Pause for 10mins to let migrations run
  health_check_grace_period_seconds = 600

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

  load_balancer {
    target_group_arn = aws_alb_target_group.websockets.id
    container_name   = "anycable_go"
    container_port   = var.websockets_port
  }

  depends_on = [
    aws_alb_listener.http,
    aws_alb_listener.websockets,
  ]
}
