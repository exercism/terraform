locals {
  az_names = data.aws_availability_zones.available.names
  az_count = length(local.az_names)
}

# The Virtual Private Cloud that holds all of
# the resources defined in this terraform
resource "aws_vpc" "main" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = "v3"
  }
}

# We get to have one internet gateway per vpc
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "v3"
  }
}

# Create public subnets, each in a different AZ
resource "aws_subnet" "publics" {
  count                   = local.az_count
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone       = local.az_names[count.index]
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = false
  tags = {
    Name = "v3 ${local.az_names[count.index]}"
  }
}

# Add in the ability for all traffic to go via the gateway
resource "aws_default_route_table" "main" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "v3"
  }
}

