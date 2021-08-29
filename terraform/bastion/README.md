# Bastion

## Usage

docker exec -it $(docker ps -f "name=rails" -q) bundle exec rails console

## TODO
Right now, I manually have to make the EC2 machine and register it.

- Ubuntu Server 20.04 LTS (HVM), SSD Volume Type (ami-0194c3e07668a7e36)
- t3a-small

This involves:
- Making an instance in the right AZ
- Giving it the ecs role
- Giving it this user data:

#!/bin/bash
echo ECS_CLUSTER=bastion >> /etc/ecs/ecs.config
