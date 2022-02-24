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
    "name": "puma",
    "image": "${rails_image}",
    "essential": true,

    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "${region}",
        "awslogs-group": "${log_group_name}",
        "awslogs-stream-prefix": "${log_group_prefix}"
      }
    },
    "mountPoints": [
      {
        "containerPath": "${efs_repositories_mount_point}",
        "sourceVolume": "efs-repositories"
      },
      {
        "containerPath": "${efs_submissions_mount_point}",
        "sourceVolume": "efs-submissions"
      }
    ],
    "cpu": 0,
    "user": "0",
    "portMappings": [
      {
        "containerPort": 3000,
        "protocol": "tcp"
      }
    ],
    "volumesFrom": [],
    "environment": [],
    "ulimits": [
      {
        "name": "nofile",
        "softLimit": 1048576,
        "hardLimit": 1048576
      }
    ],
    "healthCheck": {
      "command": [
        "CMD-SHELL",
        "curl -f http://localhost:3000/health-check || exit 1"
      ],
      "timeout": 2,
      "interval": 30,
      "startPeriod": 300,
      "retries": 3
    }
  }
]

