# Create public subnets, each in a different AZ
resource "aws_subnet" "webservers" {
  count                   = var.az_count
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, var.az_count + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = false
  tags = {
    Name = "private ${count.index}"
  }
}

# Create a new route table for the webservers
# This gives access to the internet gateway
resource "aws_route_table" "webserver" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "v3 webservers"
  }
}

# Explicitely associate the webservers route table to the webserver
# subnets so they don't default to the main route table
resource "aws_route_table_association" "webservers" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.webservers.*.id, count.index)
  route_table_id = aws_route_table.webserver.id
}
