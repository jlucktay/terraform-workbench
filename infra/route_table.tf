resource "aws_route_table" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags = "${merge(
    local.default-tags,
    map(
      "Name", "james.lucktaylor.rtb"
    )
  )}"
}

resource "aws_route" "main" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "igw-51e89b36"
  route_table_id         = "${aws_route_table.main.id}"
}

resource "aws_main_route_table_association" "main" {
  route_table_id = "${aws_route_table.main.id}"
  vpc_id         = "${aws_vpc.main.id}"
}

resource "aws_route_table_association" "main" {
  count          = "${length(data.aws_availability_zones.available.names)}"
  route_table_id = "${aws_route_table.main.id}"
  subnet_id      = "${element(aws_subnet.main.*.id, count.index)}"
}
