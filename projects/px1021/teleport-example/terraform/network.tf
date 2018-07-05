// Public subnets and routing tables used for NAT gateways and load balancers.
resource "aws_route_table" "public" {
  count  = "${length(local.azs)}"
  tags   = "${local.default_tags}"
  vpc_id = "${local.vpc_id}"
}

resource "aws_route" "public_gateway" {
  count                  = "${length(local.azs)}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${local.internet_gateway_id}"
  route_table_id         = "${element(aws_route_table.public.*.id, count.index)}"

  depends_on = [
    "aws_route_table.public",
  ]
}

resource "aws_subnet" "public" {
  availability_zone = "${element(local.azs, count.index)}"
  cidr_block        = "${cidrsubnet(var.vpc_cidr, 8, count.index+2)}"
  count             = "${length(local.azs)}"
  tags              = "${local.default_tags}"
  vpc_id            = "${local.vpc_id}"
}

resource "aws_route_table_association" "public" {
  count          = "${length(local.azs)}"
  route_table_id = "${element(aws_route_table.public.*.id, count.index)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
}
