// VPC for Teleport deployment
resource "aws_vpc" "teleport" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = "${merge(
    local.default_tags,
    map(
      "Name", "james.lucktaylor.tidal",
    )
  )}"
}

// Elastic IP for NAT gateways
resource "aws_eip" "nat" {
  count = "${length(local.azs)}"
  tags  = "${local.default_tags}"
  vpc   = true
}

// Internet gateway for NAT gateway
resource "aws_internet_gateway" "teleport" {
  tags   = "${local.default_tags}"
  vpc_id = "${aws_vpc.teleport.id}"
}

// Creates nat gateway per availability zone
resource "aws_nat_gateway" "teleport" {
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  count         = "${length(local.azs)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
  tags          = "${local.default_tags}"

  depends_on = [
    "aws_internet_gateway.teleport",
    "aws_subnet.public",
  ]
}

locals {
  internet_gateway_id = "${aws_internet_gateway.teleport.id}"
  vpc_id              = "${aws_vpc.teleport.id}"

  nat_gateways = [
    "${aws_nat_gateway.teleport.*.id}",
  ]
}
