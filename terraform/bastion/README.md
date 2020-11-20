# Bastion

## Usage

docker exec -it $(docker ps -f "name=rails" -q) bundle exec rails console

## TODO
Right now, I manually have to make the EC2 machine and register it.

This involves:
- Making an instance in the right AZ
- Giving it the ecs role
- Giving it this user data:

#!/bin/bash
echo ECS_CLUSTER=bastion >> /etc/ecs/ecs.config
