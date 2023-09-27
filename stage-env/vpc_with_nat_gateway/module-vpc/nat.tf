resource "aws_eip" "nat" {
  domain   = "vpc"
  # vpc      = true
}
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet[0].id
  depends_on    = [aws_internet_gateway.testIGW]

  tags = {
    Name = "${var.natgateway_name}-${var.env}"            ##"NAT_Gateway"
    Environment = var.env          ##"${terraform.workspace}"
  }
}
