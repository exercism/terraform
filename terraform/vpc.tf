resource "aws_vpc" "v3" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = "v3 ${var.environment}"
  }
}

resource "aws_internet_gateway" "v3" {
  vpc_id = aws_vpc.v3.id

  tags = {
    Name = "v3-${var.environment}"
  }
}

resource "aws_default_route_table" "v3" {
  default_route_table_id = aws_vpc.v3.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.v3.id
  }
}

resource "aws_subnet" "v3-a" {
  vpc_id                  = aws_vpc.v3.id
  cidr_block              = "10.1.1.0/24"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = false

  tags = {
    Name = "v3-${var.environment}-a"
  }
}
