
# ###
# Set up the cluster
# ###
resource "aws_ecs_cluster" "tooling_orchestrators" {
  name = "tooling_orchestrators"
}
locals {
  container_definition = templatefile("./tooling_orchestrator/ecs_task_definition.json.tpl", {
    application_image = "${aws_ecr_repository.application.repository_url}:latest"
    nginx_image       = "${aws_ecr_repository.nginx.repository_url}:latest"
    http_port         = var.http_port
    region            = var.region
    log_group_name    = aws_cloudwatch_log_group.tooling_orchestrators.name
  })
}
resource "aws_ecs_task_definition" "tooling_orchestrators" {
  family                   = "tooling_orchestrators"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  container_definitions    = local.container_definition
  execution_role_arn       = var.aws_iam_role_ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs.arn
  tags                     = {}
}
resource "aws_ecs_service" "tooling_orchestrators" {
  name            = "tooling_orchestrators"
  cluster         = aws_ecs_cluster.tooling_orchestrators.id
  task_definition = aws_ecs_task_definition.tooling_orchestrators.arn
  desired_count   = var.container_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.ecs.id]
    subnets         = var.aws_subnet_publics.*.id

    # TODO: Can this be false?
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

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      task_definition
    ]
  }

}
