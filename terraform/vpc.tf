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
