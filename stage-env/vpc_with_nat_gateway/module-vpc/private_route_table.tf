resource "aws_default_route_table" "default_route_table" {
  default_route_table_id = aws_vpc.test_vpc.default_route_table_id
 
   tags = {
    Name = "default-route-table-${var.env}"
    Environment = var.env               ##"${terraform.workspace}"
  }

}

resource "aws_route_table" "private_route_table_1" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
}

  tags = {
    Name = "Private-route-table-1-${var.env}"
   Environment = var.env                  ##"${terraform.workspace}"
  }
}

resource "aws_route_table_association" "private_route_table_association_1" {
#  count = "${length(slice(data.aws_availability_zones.azs.names, 0, 2))}"           ##"${length(data.aws_availability_zones.azs.names)}"
  subnet_id      = aws_subnet.private_subnet[0].id                                   ##aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table_1.id
}

resource "aws_route_table" "private_route_table_2" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
}

  tags = {
    Name = "Private-route-table-2-${var.env}"
   Environment = var.env                  ##"${terraform.workspace}"
  }
}

resource "aws_route_table_association" "private_route_table_association_2" {
#  count = "${length(slice(data.aws_availability_zones.azs.names, 0, 2))}"        ## "${length(data.aws_availability_zones.azs.names)}"
  subnet_id      = aws_subnet.private_subnet[1].id                             ## aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table_2.id
}

resource "aws_route_table" "private_route_table_3" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
}

  tags = {
    Name = "Private-route-table-3-${var.env}"
   Environment = var.env                  ##"${terraform.workspace}"
  }
}

resource "aws_route_table_association" "private_route_table_association_3" {
#  count = "${length(data.aws_availability_zones.azs.names)}"       ##"${length(slice(data.aws_availability_zones.azs.names, 0, 2))}"
  subnet_id      = aws_subnet.private_subnet[2].id         ## aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table_3.id
}
