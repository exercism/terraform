# ###
# Set up an iam role that allows servers to write
# to any services required.
# ###

resource "aws_iam_role" "ecs" {
  name               = "tooling-orchestrator-ecs"
  assume_role_policy = var.aws_iam_policy_document_assume_role_ecs.json
}
resource "aws_iam_role_policy_attachment" "write_to_cloudwatch" {
  role       = aws_iam_role.ecs.name
  policy_arn = var.aws_iam_policy_write_to_cloudwatch.arn
}
resource "aws_iam_role_policy_attachment" "access_dynamodb" {
  role       = aws_iam_role.ecs.name
  policy_arn = var.aws_iam_policy_access_dynamodb.arn
}


# ###
# Set up the cluster
# ###
resource "aws_ecs_cluster" "tooling_orchestrators" {
  name = "tooling_orchestrators"
}
data "template_file" "tooling_orchestrators" {
  template = file("./tooling_orchestrator/ecs_task_definition.json.tpl")

  vars = {
    application_image = "${aws_ecr_repository.application.repository_url}:latest"
    nginx_image       = "${aws_ecr_repository.nginx.repository_url}:latest"
    http_port         = var.http_port
    region            = var.region
    log_group_name    = aws_cloudwatch_log_group.tooling_orchestrators.name
  }
}
resource "aws_ecs_task_definition" "tooling_orchestrators" {
  family                   = "tooling_orchestrators"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  container_definitions    = data.template_file.tooling_orchestrators.rendered
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
