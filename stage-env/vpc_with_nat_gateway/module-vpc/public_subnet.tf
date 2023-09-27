resource "aws_subnet" "public_subnet" {
  count = "${length(data.aws_availability_zones.azs.names)}"
  vpc_id     = "${aws_vpc.test_vpc.id}"
  availability_zone = "${element(data.aws_availability_zones.azs.names,count.index)}"
  cidr_block = "${element(var.public_subnet_cidr,count.index)}"
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet-${var.env}-${count.index+1}"
    Environment = var.env            ##"${terraform.workspace}"
  }
}
