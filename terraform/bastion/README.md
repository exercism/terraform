# Bastion

## Usage

docker exec -it $(docker ps -f "name=rails" -q) bundle exec rails console

## TODO
Right now, I manually have to make the EC2 machine and register it.

- Ubuntu Server 20.04 LTS (HVM),
- x86
- SSD Volume Type (ami-0194c3e07668a7e36)
- t3a-small

Key is iHiD-v3

Change to v3 vpc

Sec Groups: bastion-ec2, efs-repositories-access, efs-submissions-access, iHiD-ssh-access

Mount the two EFS filesystems
- /mnt/efs/repos
- /mnt/efs/submissions

Set iam Profile: 

Untick "Auto create security groups"

<!-- This involves: -->
<!-- - Making an instance in the right AZ -->
<!-- - Giving it the ecs role -->
<!-- - Giving it this user data: -->

<!-- #!/bin/bash -->
<!-- echo ECS_CLUSTER=bastion >> /etc/ecs/ecs.config -->
