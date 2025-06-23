[
  {
    "name": "sidekiq",
    "image": "${rails_image}",
    "essential": false,
    "environment": [
      {"name": "RAILS_ENV", "value": "production"}
    ],
    "entryPoint": ["bundle", "exec", "bin/start_sidekiq"],

    "logConfiguration": {
      "logDriver":"awslogs",
      "options": {
        "awslogs-region": "${region}",
        "awslogs-group": "${log_group_name}",
        "awslogs-stream-prefix": "sidekiq/"
      }
    },
    "cpu": 0,
    "user": "0",
    "mountPoints": [
      {
        "containerPath": "${efs_repositories_mount_point}",
        "sourceVolume": "efs-repositories"
      },
      {
        "containerPath": "${efs_tooling_jobs_mount_point}",
        "sourceVolume": "efs-tooling-jobs"
      }
    ],
    "portMappings": [],
    "volumesFrom": [],
    "ulimits": [
      {
        "name": "nofile",
        "softLimit": 1048576,
        "hardLimit": 1048576
      }
    ]
  },
  {
    "name": "monitor",
    "image": "${monitor_image}",
    "essential": true,
    "portMappings": [
      {
        "containerPort": ${monitor_port},
        "protocol": "tcp"
      }
    ],

    "logConfiguration": {
      "logDriver":"awslogs",
      "options": {
        "awslogs-region": "${region}",
        "awslogs-group": "${log_group_name}",
        "awslogs-stream-prefix": "monitor/"
      }
    },
    "cpu": 0,
    "user": "0",
    "mountPoints": [],
    "volumesFrom": [],
    "environment": []
  }
]
