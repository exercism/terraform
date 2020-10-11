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
    "name": "puma",
    "image": "${rails_image}",
    "essential": true,

    "logConfiguration": {
      "logDriver":"awsfirelens",
      "options": {
        "Name": "cloudwatch",
        "region": "${region}",
        "log_group_name": "${log_group_name}",
        "log_stream_prefix": "puma/"
      }
    },
    "cpu": 0,
    "user": "0",
    "mountPoints": [],
    "portMappings": [],
    "volumesFrom": [],
    "environment": []
  },
  {
    "name": "anycable_ruby",
    "image": "${rails_image}",
    "essential": true,
    "environment": [
      {"name": "RAILS_ENV", "value": "production"}
    ],
    "entryPoint": ["bundle", "exec", "anycable"],

    "logConfiguration": {
      "logDriver":"awsfirelens",
      "options": {
        "Name": "cloudwatch",
        "region": "${region}",
        "log_group_name": "${log_group_name}",
        "log_stream_prefix": "anycable-ruby/"
      }
    },
    "cpu": 0,
    "user": "0",
    "mountPoints": [],
    "portMappings": [],
    "volumesFrom": []
  },
  {
    "name": "anycable_go",
    "image": "${anycable_go_image}",
    "essential": true,
    "portMappings": [
      {
        "containerPort": ${websockets_port},
        "protocol": "tcp"
      }
    ],
    "environment": [
      {"name": "ANYCABLE_REDIS_URL", "value": "${anycable_redis_url}"},
      {"name": "ANYCABLE_HOST", "value": "0.0.0.0"},
      {"name": "ANYCABLE_PORT", "value": "${websockets_port}"},
      {"name": "ANYCABLE_RPC_HOST", "value": "127.0.0.1:50051"},
      {"name": "ANYCABLE_DEBUG", "value": "true"}
    ],
    "logConfiguration": {
      "logDriver":"awsfirelens",
      "options": {
        "Name": "cloudwatch",
        "region": "${region}",
        "log_group_name": "${log_group_name}",
        "log_stream_prefix": "anycable-go/"
      }
    },
    "cpu": 0,
    "user": "0",
    "mountPoints": [],
    "volumesFrom": []
  }
]
