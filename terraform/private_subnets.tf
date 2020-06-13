# Create private subnets, each in a different AZ
resource "aws_subnet" "privates" {
  count             = var.az_count
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, (var.az_count * 2) + count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.main.id

  tags = {
    Name = "v3 private ${data.aws_availability_zones.available.names[count.index]}"
  }
}

# Create a NAT gateway with an Elastic IP for each
# private subnet to get internet connectivity
resource "aws_eip" "private_gateways" {
  count = var.az_count
  vpc   = true

  tags = {
    Name = "v3 private ${data.aws_availability_zones.available.names[count.index]}"
  }
}
resource "aws_nat_gateway" "privates" {
  count         = var.az_count
  subnet_id     = element(aws_subnet.privates.*.id, count.index)
  allocation_id = element(aws_eip.private_gateways.*.id, count.index)

  tags = {
    Name = "v3 private ${data.aws_availability_zones.available.names[count.index]}"
  }
}

# Create a new route table for the private subnets and make
# it route non-local traffic through the NAT gateway to the internet
resource "aws_route_table" "privates" {
  count  = var.az_count
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.privates.*.id, count.index)
  }

  tags = {
    Name = "v3 private ${data.aws_availability_zones.available.names[count.index]}"
  }
}

# Explicitely associate the private route tables to the private
# subnets so they don't default to the main route table
resource "aws_route_table_association" "private" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.privates.*.id, count.index)
  route_table_id = element(aws_route_table.privates.*.id, count.index)
}
