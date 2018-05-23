resource "aws_subnet" "main" {
  availability_zone       = "${element(data.aws_availability_zones.available.names, count.index)}"
  cidr_block              = "${cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + 1)}"
  count                   = "${length(data.aws_availability_zones.available.names)}"
  map_public_ip_on_launch = true
  vpc_id                  = "${aws_vpc.main.id}"

  tags = "${merge(
    local.default-tags,
    map(
      "Name", "james.lucktaylor.subnet.${substr(element(data.aws_availability_zones.available.names, count.index), -1, -1)}"
    )
  )}"
}
