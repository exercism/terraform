[
  {
    "name": "sidekiq",
    "image": "${rails_image}",
    "essential": true,
    "environment": [
      {"name": "RAILS_ENV", "value": "production"}
    ],
    "entryPoint": ["bundle", "exec", "sidekiq"],

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
        "containerPath": "${efs_submissions_mount_point}",
        "sourceVolume": "efs-submissions"
      }
    ],
    "portMappings": [],
    "volumesFrom": []
  }
]

