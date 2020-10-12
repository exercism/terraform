# ###
# Set up an iam role that allows servers to write
# to any services required.
# ###

resource "aws_iam_role" "ecs_tooling_orchestrator" {
  name               = "ecs_tooling_orchestrator"
  assume_role_policy = var.aws_iam_policy_document_assume_ecs_role.json
}
resource "aws_iam_role_policy_attachment" "ecs_tooling_orchestrator_write_to_cloudwatch" {
  role       = aws_iam_role.ecs_tooling_orchestrator.name
  policy_arn = var.aws_iam_policy_write_to_cloudwatch.arn
}
resource "aws_iam_role_policy_attachment" "ecs_tooling_orchestrator_access_dynamodb" {
  role       = aws_iam_role.ecs_tooling_orchestrator.name
  policy_arn = var.aws_iam_policy_access_dynamodb.arn
}


# ###
# Set up the cluster
# ###
resource "aws_ecs_cluster" "tooling_orchestrators" {
  name = "tooling_orchestrators"
}
data "template_file" "tooling_orchestrators" {
  template = file("./templates/ecs_tooling_orchestrators.json.tpl")

  vars = {
    image         = "${aws_ecr_repository.tooling_orchestrator.repository_url}:latest"
    http_port           = var.tooling_orchestrators_http_port
    region              = var.region
    log_group_name      = aws_cloudwatch_log_group.tooling_orchestrators.name
  }
}
resource "aws_ecs_task_definition" "tooling_orchestrators" {
  family                   = "tooling_orchestrators"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.tooling_orchestrators_cpu
  memory                   = var.tooling_orchestrators_memory
  container_definitions    = data.template_file.tooling_orchestrators.rendered
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs_tooling_orchestrator.arn
  tags                     = {}
}
resource "aws_ecs_service" "tooling_orchestrators" {
  name            = "tooling_orchestrators"
  cluster         = aws_ecs_cluster.tooling_orchestrators.id
  task_definition = aws_ecs_task_definition.tooling_orchestrators.arn
  desired_count   = var.tooling_orchestrators_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tooling_orchestrators.id]
    subnets          = aws_subnet.publics.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.tooling_orchestrators_http.id
    container_name   = "tooling_orchestrator"
    container_port   = var.tooling_orchestrators_http_port
  }

  depends_on = [
    aws_alb_listener.tooling_orchestrators_http,
    aws_iam_role_policy_attachment.ecs_task_execution_role,
    aws_security_group.ecs_tooling_orchestrators
  ]
}
