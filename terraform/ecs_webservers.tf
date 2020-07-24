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
resource "aws_iam_policy" "write_to_cloudwatch" {
  name        = "write_to_cloudwatch"
  path        = "/"
  description = "Write to CloudWatch"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents"
    ],
    "Resource": "*"
  }]
}
EOF
}
resource "aws_iam_role" "ecs_webservers" {
  name               = "ecs_webservers"
  assume_role_policy = data.aws_iam_policy_document.assume_ecs_role.json
}
resource "aws_iam_role_policy_attachment" "write_to_cloudwatch" {
  role       = aws_iam_role.ecs_webservers.name
  policy_arn = aws_iam_policy.write_to_cloudwatch.arn
}
# ###
# Set up the cluster
# ###
resource "aws_ecs_cluster" "webservers" {
  name = "webservers"
}
data "template_file" "webservers" {
  template = file("./templates/ecs_webservers.json.tpl")

  vars = {
    image          = "${aws_ecr_repository.webservers.repository_url}:a6655abc0b1086c7d301182b3a37a0e796620e17"
    port           = var.webservers_port
    region         = var.region
    log_group_name = aws_cloudwatch_log_group.webservers.name
  }
}
resource "aws_ecs_task_definition" "webserver" {
  family                   = "webserver"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.webservers_cpu
  memory                   = var.webservers_memory
  container_definitions    = data.template_file.webservers.rendered
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs_webservers.arn
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
