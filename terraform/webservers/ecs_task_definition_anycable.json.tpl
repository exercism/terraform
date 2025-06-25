[
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
      "logDriver":"awslogs",
      "options": {
        "awslogs-region": "${region}",
        "awslogs-group": "${log_group_name}",
        "awslogs-stream-prefix": "${log_group_prefix}"
      }
    },
    "cpu": 0,
    "user": "0",
    "mountPoints": [],
    "volumesFrom": [],
    "environment": [],
    "ulimits": [
      {
        "name": "nofile",
        "softLimit": 1048576,
        "hardLimit": 1048576
      }
    ]
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
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "${region}",
        "awslogs-group": "${log_group_name}",
        "awslogs-stream-prefix": "${log_group_prefix}"
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
    "environment": [
      {"name": "ANYCABLE_REDIS_URL", "value": "${anycable_redis_url}"},
      {"name": "ANYCABLE_HOST", "value": "0.0.0.0"},
      {"name": "ANYCABLE_PORT", "value": "3035"},
      {"name": "ANYCABLE_HEALTH_PATH", "value": "/cable/health"},
      {"name": "ANYCABLE_RPC_HOST", "value": "127.0.0.1:50051"},
      {"name": "ANYCABLE_DEBUG", "value": "false"},
      {"name": "ANYCABLE_LOG_LEVEL", "value": "error"}
    ],
    "logConfiguration": {
      "logDriver":"awslogs",
      "options": {
        "awslogs-region": "${region}",
        "awslogs-group": "${log_group_name}",
        "awslogs-stream-prefix": "${log_group_prefix}"
      }
    },
    "cpu": 0,
    "user": "0",
    "mountPoints": [],
    "volumesFrom": [],
    "ulimits": [
      {
        "name": "nofile",
        "softLimit": 1048576,
        "hardLimit": 1048576
      }
    ]
  }
]

