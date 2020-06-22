resource "aws_ecs_cluster" "webservers" {
  name = "webservers"
}

data "template_file" "webservers" {
  template = file("./templates/ecs_webservers.json.tpl")

  vars = {
    image  = var.webservers_image
    port   = var.webservers_port
  }
}

resource "aws_ecs_task_definition" "webserver" {
  family                   = "webserver"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.webservers_cpu
  memory                   = var.webservers_memory
  container_definitions    = data.template_file.webservers.rendered
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
}

resource "aws_ecs_service" "webservers" {
  name            = "webservers"
  cluster         = aws_ecs_cluster.webservers.id
  task_definition = aws_ecs_task_definition.webserver.arn
  desired_count   = var.webservers_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.webservers.id]
    subnets          = aws_subnet.publics.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.webservers.id
    container_name   = "webserver"
    container_port   = var.webservers_port
  }

  depends_on = [aws_alb_listener.webservers, aws_iam_role_policy_attachment.ecs_task_execution_role]
}
