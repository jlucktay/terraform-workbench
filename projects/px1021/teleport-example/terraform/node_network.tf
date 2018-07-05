// Node subnets are for teleport nodes joining the cluster
// Nodes are not accessible via internet and are accessed via emergency access bastions or proxies
resource "aws_route_table" "node" {
  count  = "${length(local.azs)}"
  tags   = "${local.default_tags}"
  vpc_id = "${local.vpc_id}"
}

// Route all outbound traffic through NAT gateway
resource "aws_route" "node" {
  count                  = "${length(local.azs)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(local.nat_gateways, count.index)}"
  route_table_id         = "${element(aws_route_table.node.*.id, count.index)}"

  depends_on = [
    "aws_route_table.node",
  ]
}

resource "aws_subnet" "node" {
  availability_zone = "${element(local.azs, count.index)}"
  cidr_block        = "${cidrsubnet(var.vpc_cidr, 6, count.index+1)}"
  count             = "${length(local.azs)}"
  tags              = "${local.default_tags}"
  vpc_id            = "${local.vpc_id}"
}

resource "aws_route_table_association" "node" {
  count          = "${length(local.azs)}"
  route_table_id = "${element(aws_route_table.node.*.id, count.index)}"
  subnet_id      = "${element(aws_subnet.node.*.id, count.index)}"
}

// Node security groups do not allow direct internet access and only allow traffic coming in from proxies or emergency access bastions
resource "aws_security_group" "node" {
  name   = "${var.cluster_name}-node"
  tags   = "${local.default_tags}"
  vpc_id = "${local.vpc_id}"
}

// SSH access is allowed via bastions and proxies
resource "aws_security_group_rule" "node_ingress_allow_ssh_bastion" {
  from_port                = 22
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.node.id}"
  source_security_group_id = "${aws_security_group.bastion.id}"
  to_port                  = 22
  type                     = "ingress"
}

resource "aws_security_group_rule" "node_ingress_allow_ssh_proxy" {
  from_port                = 3022
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.node.id}"
  source_security_group_id = "${aws_security_group.proxy.id}"
  to_port                  = 3022
  type                     = "ingress"
}

resource "aws_security_group_rule" "node_egress_allow_all_traffic" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.node.id}"
  to_port           = 0
  type              = "egress"

  cidr_blocks = [
    "0.0.0.0/0",
  ]
}
