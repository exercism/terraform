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
        "awslogs-stream-prefix": "nginx/"
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
      "logDriver":"awslogs",
      "options": {
        "awslogs-region": "${region}",
        "awslogs-group": "${log_group_name}",
        "awslogs-stream-prefix": "application/"
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
