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
        "awslogs-stream-prefix": "language-servers"
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
    "name": "proxy",
    "image": "${proxy_image}",
    "essential": true,
    "portMappings": [
      {
        "containerPort": ${websockets_port},
        "hostPort": ${websockets_port},
        "protocol": "tcp"
      }
    ],

    "logConfiguration": {
      "logDriver":"awsfirelens",
      "options": {
        "Name": "cloudwatch",
        "region": "${region}",
        "log_group_name": "${log_group_name}",
        "log_stream_prefix": "proxy/"
      }
    },
    "cpu": 0,
    "user": "0",
    "mountPoints": [],
    "volumesFrom": [],
    "environment": [
      {"name": "RUBY_LANGUAGE_SERVER_HOST", "value": "ruby-language-server"},
      {"name": "RUBY_LANGUAGE_SERVER_PORT", "value": "7658"}
    ]
  },
  {
    "name": "ruby_language_server",
    "image": "${ruby_ls_image}",
    "essential": true,

    "logConfiguration": {
      "logDriver":"awsfirelens",
      "options": {
        "Name": "cloudwatch",
        "region": "${region}",
        "log_group_name": "${log_group_name}",
        "log_stream_prefix": "ruby_language_server/"
      }
    },
    "cpu": 0,
    "user": "0",
    "mountPoints": [],
    "portMappings": [],
    "volumesFrom": [],
    "environment": [
      {"name": "PROXY_HOST", "value": "proxy"},
      {"name": "PROXY_PORT", "value": "4444"}
    ]
  }
]
