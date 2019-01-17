resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_route_table_association" "public" {
  route_table_id = "${aws_route_table.public.id}"

  subnet_id = "${aws_subnet.main.id}"
}

resource "aws_route" "public-igw" {
  route_table_id = "${aws_route_table.public.id}"

  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.main.id}"
}
