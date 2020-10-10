# ###
# Set up an iam role that allows for ECS task execution
# ###
data "aws_iam_policy_document" "assume_ecs_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "ecs_task_execution" {
  name               = "ecs_task_execution"
  assume_role_policy = data.aws_iam_policy_document.assume_ecs_role.json
}
resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ###
# Set up an iam role that allows for task execution
# ###

resource "aws_iam_role" "ecs_webserver" {
  name               = "ecs_webserver"
  assume_role_policy = data.aws_iam_policy_document.assume_ecs_role.json
}
resource "aws_iam_role_policy_attachment" "webservers_write_to_cloudwatch" {
  role       = aws_iam_role.ecs_webserver.name
  policy_arn = aws_iam_policy.write_to_cloudwatch.arn
}
resource "aws_iam_role_policy_attachment" "webservers_access_dynamodb" {
  role       = aws_iam_role.ecs_webserver.name
  policy_arn = aws_iam_policy.access_dynamodb.arn
}
# ###
# Set up the cluster
# ###
resource "aws_ecs_cluster" "webservers" {
  name = "webservers"
}
data "template_file" "webserver" {
  template = file("./templates/ecs_webserver.json.tpl")

  vars = {
    nginx_image         = "${aws_ecr_repository.webserver_nginx.repository_url}:latest"
    rails_image          = "${aws_ecr_repository.webserver_rails.repository_url}:latest"
    anycable_go_image   = "${aws_ecr_repository.webserver_anycable_go.repository_url}:latest"
    anycable_redis_url  = local.anycable_redis_url
    http_port           = var.webservers_http_port
    websockets_port     = var.webservers_websockets_port
    region              = var.region
    log_group_name      = aws_cloudwatch_log_group.webservers.name
  }
}
resource "aws_ecs_task_definition" "webserver" {
  family                   = "webserver"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.webservers_cpu
  memory                   = var.webservers_memory
  container_definitions    = data.template_file.webserver.rendered
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs_webserver.arn
  tags                     = {}
}
resource "aws_ecs_service" "webservers" {
  name            = "webservers"
  cluster         = aws_ecs_cluster.webservers.id
  task_definition = aws_ecs_task_definition.webserver.arn
  desired_count   = var.webservers_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_webservers.id]
    subnets          = aws_subnet.publics.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.webservers_http.id
    container_name   = "nginx"
    container_port   = var.webservers_http_port
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.webservers_websockets.id
    container_name   = "anycable_go"
    container_port   = var.webservers_websockets_port
  }

  depends_on = [
    aws_alb_listener.webservers_http,
    aws_alb_listener.webservers_websockets,
    aws_iam_role_policy_attachment.ecs_task_execution_role,
    aws_security_group.ecs_webservers
  ]
}
