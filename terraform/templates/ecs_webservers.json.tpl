[
  {
    "name": "webserver",
    "image": "${image}",
    "portMappings": [
      {
        "containerPort": ${port},
        "hostPort": ${port},
        "protocol": "tcp"
      }
    ]
  }
]
