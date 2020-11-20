
# ###
# Set up the cluster
# ###
resource "aws_ecs_cluster" "language_servers" {
  name = "language-servers"
}
data "template_file" "language_servers" {
  template = file("./tooling_orchestrator/ecs_task_definition.json.tpl")

  vars = {
    application_image = "${element(aws_ecr_repository.language_servers, 0).repository_url}:latest"
    proxy_image       = "${aws_ecr_repository.proxy.repository_url}:latest"
    websockets_port   = var.websockets_port
    region            = var.region
    log_group_name    = aws_cloudwatch_log_group.language_servers.name
  }
}
resource "aws_ecs_task_definition" "language_servers" {
  family                   = "language-servers"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  container_definitions    = data.template_file.language_servers.rendered
  execution_role_arn       = var.aws_iam_role_ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs.arn
  tags                     = {}
}
resource "aws_ecs_service" "language_servers" {
  name            = "language-servers"
  cluster         = aws_ecs_cluster.language_servers.id
  task_definition = aws_ecs_task_definition.language_servers.arn
  desired_count   = var.container_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs.id]
    subnets          = var.aws_subnet_publics.*.id

    # TODO: Can this be false?
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.websockets.id
    container_name   = "proxy"
    container_port   = var.websockets_port
  }

  depends_on = [
    aws_alb_listener.websockets
  ]
}
