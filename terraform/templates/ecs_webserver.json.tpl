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
        "awslogs-stream-prefix": "firelens"
      }
    },
    "cpu": 0,
    "memoryReservation": 0,
    "user": "0",
    "mountPoints": [],
    "portMappings": [],
    "volumesFrom": [],
    "environment": []
  },
  {
    "name": "nginx",
    "image": "${nginx_image}",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "protocol": "tcp"
      }
    ],
    "links": [
      "puma"
    ],

    "logConfiguration": {
      "logDriver":"awsfirelens",
      "options": {
        "Name": "cloudwatch",
        "region": "${region}",
        "log_group_name": "${log_group_name}",
        "log_stream_prefix": "nginx"
      }
    },
    "cpu": 0,
    "memoryReservation": 0,
    "user": "0",
    "mountPoints": [],
    "portMappings": [],
    "volumesFrom": [],
    "environment": []
  },
  {
    "name": "puma",
    "image": "${puma_image}",
    "essential": true,
    "links": [
      "anycable_ruby",
      "anycable_go"
    ],

    "logConfiguration": {
      "logDriver":"awsfirelens",
      "options": {
        "Name": "cloudwatch",
        "region": "${region}",
        "log_group_name": "${log_group_name}",
        "log_stream_prefix": "puma"
      }
    },
    "cpu": 0,
    "memoryReservation": 0,
    "user": "0",
    "mountPoints": [],
    "portMappings": [],
    "volumesFrom": [],
    "environment": []
  },
  {
    "name": "anycable_ruby",
    "image": "${anycable_ruby_image}",
    "essential": true,

    "logConfiguration": {
      "logDriver":"awsfirelens",
      "options": {
        "Name": "cloudwatch",
        "region": "${region}",
        "log_group_name": "${log_group_name}",
        "log_stream_prefix": "anycable_ruby"
      }
    },
    "cpu": 0,
    "memoryReservation": 0,
    "user": "0",
    "mountPoints": [],
    "portMappings": [],
    "volumesFrom": [],
    "environment": []
  },
  {
    "name": "anycable_go",
    "image": "${anycable_go_image}",
    "essential": true,
    "command": ["--redis_url=${anycable_redis_url}"],
    "links": [
      "anycable_ruby"
    ],

    "logConfiguration": {
      "logDriver":"awsfirelens",
      "options": {
        "Name": "cloudwatch",
        "region": "${region}",
        "log_group_name": "${log_group_name}",
        "log_stream_prefix": "anycable_go"
      }
    },
    "cpu": 0,
    "memoryReservation": 0,
    "user": "0",
    "mountPoints": [],
    "portMappings": [],
    "volumesFrom": [],
    "environment": []
  }
]
