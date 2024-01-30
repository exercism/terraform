locals {
  az_names = data.aws_availability_zones.available.names
  az_count = length(local.az_names)
}

# The Virtual Private Cloud that holds all of
# the resources defined in this terraform
resource "aws_vpc" "main" {
  cidr_block           = "10.1.0.0/16"
  assign_generated_ipv6_cidr_block = true
       # ipv6_cidr_block                      = "2a05:d01c:69d:9b00::/56"
       # ipv6_ipam_pool_id = ""
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
}

# Create public subnets, each in a different AZ
resource "aws_subnet" "publics" {
  count                   = local.az_count
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
       ipv6_cidr_block                                = "2a05:d01c:69d:9b00::/56"
  availability_zone       = local.az_names[count.index]
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true
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

# Create a private subnet for lambdas
resource "aws_subnet" "lambda" {
  vpc_id                  = aws_vpc.main.id

  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 4)
       ipv6_cidr_block                                = "2a05:d01c:d38:b600::/56"
  availability_zone       = local.az_names[0]
  tags = {
    Name = "V3 Lambda (private)"
  }
}

resource "aws_eip" "nat_gateway_lambda" { }

resource "aws_nat_gateway" "lambda" {
  allocation_id = aws_eip.nat_gateway_lambda.id
  subnet_id     = aws_subnet.publics[0].id

  depends_on = [aws_internet_gateway.main]
}

# Add in the ability for all traffic to go via the gateway
resource "aws_route_table" "lambda" {
  vpc_id                  = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.lambda.id
  }

  tags = {
    Name = "v3 - Lambda"
  }
}
resource "aws_route_table_association" "lambda" {
  subnet_id      = aws_subnet.lambda.id
  route_table_id = aws_route_table.lambda.id
}

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.eu-west-2.dynamodb"
  route_table_ids = [
    aws_vpc.main.default_route_table_id,
    aws_route_table.lambda.id
  ]

  auto_accept = true
}

# *********
# If we ever want to remove the public IPs from our ECS
# instances, then we need the code below
# *********
# resource "aws_vpc_endpoint" "ecr_dkr" {
#   vpc_id       = aws_vpc.main.id
#   service_name = "com.amazonaws.eu-west-2.ecr.dkr"
#   vpc_endpoint_type = "Interface"

#   auto_accept = true
# }

# resource "aws_vpc_endpoint" "ecr_api" {
#   vpc_id       = aws_vpc.main.id
#   service_name = "com.amazonaws.eu-west-2.ecr.api"
#   vpc_endpoint_type = "Interface"

#   auto_accept = true
# }

# resource "aws_vpc_endpoint" "awslogs" {
#   vpc_id       = aws_vpc.main.id
#   service_name = "com.amazonaws.eu-west-2.logs"
#   vpc_endpoint_type = "Interface"

#   auto_accept = true
# }

# resource "aws_vpc_endpoint" "s3" {
#   vpc_id       = aws_vpc.main.id
#   service_name = "com.amazonaws.eu-west-2.s3"
#   route_table_ids = [
#     aws_vpc.main.default_route_table_id
#   ]

#   auto_accept = true
# }

# resource "aws_vpc_endpoint_policy" "s3" {
#   vpc_endpoint_id = aws_vpc_endpoint.s3.id
#   policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Statement" : [
#       {
#         "Sid" : "Access-to-specific-bucket-only",
#         "Principal" : "*",
#         "Action" : [
#           "s3:GetObject"
#         ],
#         "Effect" : "Allow",
#         "Resource" : ["arn:aws:s3:::prod-eu-west-2-starport-layer-bucket/*"]
#       }
#     ]
#   })
# }
