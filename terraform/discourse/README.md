# Creating a Discourse Server

## Setup an EC2 Machine
Right now, we manually have to make the EC2 machine and register it.

- Specs
  - Ubuntu Server 20.04 LTS (HVM),
  - x86
  - SSD Volume Type (ami-0194c3e07668a7e36)
  - t3a-small

- Key is iHiD-v3
- Change to v3 vpc
- Select security groups:
- Sec Groups: discourse-ec2, iHiD-ssh-access
- Set 20 GB storage
- Set iam Profile: discourse-ec2
- Termination protection: Enabled

## Setup

### On RDS

```
CREATE EXTENSION hstore;
CREATE EXTENSION pg_trgm;
```

### On EC2

Get SMTP detals from AWS secretsmanager.

```bash
sudo -s
git clone https://github.com/discourse/discourse_docker.git /var/discourse
cd /var/discourse
chmod 700 containers

./discourse-setup

# Follow the instructions below

```

- [Return] to install Docker
- forum.exercism.org
- 

## Most recent IP

`13.40.159.172`
