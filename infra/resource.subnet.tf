# resource "aws_default_subnet" "default" {}

resource "aws_subnet" "private" {
  availability_zone       = "${element(data.aws_availability_zones.available.names, count.index)}"
  cidr_block              = "${cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + 128)}"
  count                   = "${length(data.aws_availability_zones.available.names)}"
  map_public_ip_on_launch = false
  vpc_id                  = "${aws_vpc.main.id}"

  tags = {
    Name = "james.lucktaylor.subnet.${substr(element(data.aws_availability_zones.available.names, count.index), -1, -1)}.private"
    Tier = "Private"
  }
}

resource "aws_subnet" "public" {
  availability_zone       = "${element(data.aws_availability_zones.available.names, count.index)}"
  cidr_block              = "${cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)}"
  count                   = "${length(data.aws_availability_zones.available.names)}"
  map_public_ip_on_launch = true
  vpc_id                  = "${aws_vpc.main.id}"

  tags = {
    Name = "james.lucktaylor.subnet.${substr(element(data.aws_availability_zones.available.names, count.index), -1, -1)}.public"
    Tier = "Public"
  }
}
