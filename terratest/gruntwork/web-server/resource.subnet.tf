resource "aws_subnet" "main" {
  availability_zone       = "${element(data.aws_availability_zones.available.names, count.index)}"
  cidr_block              = "${cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)}"
  map_public_ip_on_launch = true
  vpc_id                  = "${aws_vpc.main.id}"
}
