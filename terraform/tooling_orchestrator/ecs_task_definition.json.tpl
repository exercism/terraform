[
  {
    "name": "log_router",
    "image": "906394416424.dkr.ecr.eu-west-2.amazonaws.com/aws-for-fluent-bit:latest",
    "essential": true,
    "firelensConfiguration": {
      "type": "fluentbit",
      "options": {
        "enable-ecs-log-metadata": "true"
      }
    },
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${log_group_name}",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "webservers"
      }
    },
    "cpu": 0,
    "user": "0",
    "mountPoints": [],
    "portMappings": [],
    "volumesFrom": [],
    "environment": [ ]
  },
  {
    "name": "nginx",
    "image": "${nginx_image}",
    "essential": true,
    "portMappings": [
      {
        "containerPort": ${http_port},
        "protocol": "tcp"
      }
    ],

    "logConfiguration": {
      "logDriver":"awsfirelens",
      "options": {
        "Name": "cloudwatch",
        "region": "${region}",
        "log_group_name": "${log_group_name}",
        "log_stream_prefix": "nginx/"
      }
    },
    "cpu": 0,
    "user": "0",
    "mountPoints": [],
    "volumesFrom": [],
    "environment": []
  },
  {
    "name": "application",
    "image": "${application_image}",
    "essential": true,

    "logConfiguration": {
      "logDriver":"awsfirelens",
      "options": {
        "Name": "cloudwatch",
        "region": "${region}",
        "log_group_name": "${log_group_name}",
        "log_stream_prefix": "application/"
      }
    },
    "cpu": 0,
    "user": "0",
    "mountPoints": [],
    "portMappings": [],
    "volumesFrom": [],
    "environment": []
  }
]
