resource "aws_subnet" "main" {
  availability_zone       = "${data.aws_region.current.name}${element(var.az, count.index % length(var.az))}"
  cidr_block              = "${cidrsubnet(aws_vpc.main.cidr_block, 8, count.index+1)}"
  count                   = "${length(var.az)}"
  map_public_ip_on_launch = false
  vpc_id                  = "${aws_vpc.main.id}"

  tags = "${merge(
    local.default-tags,
    map(
      "Name", "james.lucktaylor.subnet.${element(var.az, count.index % length(var.az))}"
    )
  )}"
}
