resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.testIGW.id
  }

  tags = {
    Name = "public-route-table-${var.env}"
    Environment = var.env              ##"${terraform.workspace}"
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  count = "${length(data.aws_availability_zones.azs.names)}"
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}
