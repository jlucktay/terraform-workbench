// Auth subnets are for authentication servers
resource "aws_route_table" "auth" {
  count  = "${length(local.azs)}"
  tags   = "${local.default_tags}"
  vpc_id = "${local.vpc_id}"
}

// Route all outbound traffic through NAT gateway
// Auth servers do not have public IP address and are located in their own subnet restricted by security group rules.
resource "aws_route" "auth" {
  count                  = "${length(local.azs)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(local.nat_gateways, count.index)}"
  route_table_id         = "${element(aws_route_table.auth.*.id, count.index)}"

  depends_on = [
    "aws_route_table.auth",
  ]
}

// This is a private subnet for auth servers.
resource "aws_subnet" "auth" {
  availability_zone = "${element(local.azs, count.index)}"
  cidr_block        = "${cidrsubnet(var.vpc_cidr, 8, count.index)}"
  count             = "${length(local.azs)}"
  tags              = "${local.default_tags}"
  vpc_id            = "${local.vpc_id}"
}

resource "aws_route_table_association" "auth" {
  count          = "${length(local.azs)}"
  subnet_id      = "${element(aws_subnet.auth.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.auth.*.id, count.index)}"
}

// Security groups for auth servers only allow access to 3025 port from public subnets, and not the internet
resource "aws_security_group" "auth" {
  name   = "${var.cluster_name}-auth"
  tags   = "${local.default_tags}"
  vpc_id = "${local.vpc_id}"
}

// SSH emergency access via bastion security groups
resource "aws_security_group_rule" "auth_ingress_allow_ssh" {
  from_port                = 22
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.auth.id}"
  source_security_group_id = "${aws_security_group.bastion.id}"
  to_port                  = 22
  type                     = "ingress"
}

// Internal traffic within the security group is allowed.
resource "aws_security_group_rule" "auth_ingress_allow_internal_traffic" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.auth.id}"
  self              = true
  to_port           = 0
  type              = "ingress"
}

// Allow traffic from public subnet to auth servers - this is to let proxies to talk to auth server API.
// This rule uses CIDR as opposed to security group ip becasue traffic coming from NLB (network load balancer from Amazon) is not marked with security group ID and rules using the security group ids do not work, so CIDR ranges are necessary.
resource "aws_security_group_rule" "auth_ingress_allow_cidr_traffic" {
  from_port         = 3025
  protocol          = "tcp"
  security_group_id = "${aws_security_group.auth.id}"
  to_port           = 3025
  type              = "ingress"

  cidr_blocks = [
    "${aws_subnet.public.*.cidr_block}",
  ]
}

// Allow traffic from nodes to auth servers.
// Teleport nodes heartbeat presence to auth server.
// This rule uses CIDR as opposed to security group ip becasue traffic coming from NLB (network load balancer from Amazon) is not marked with security group ID and rules using the security group ids do not work, so CIDR ranges are necessary.
resource "aws_security_group_rule" "auth_ingress_allow_node_cidr_traffic" {
  from_port         = 3025
  protocol          = "tcp"
  security_group_id = "${aws_security_group.auth.id}"
  to_port           = 3025
  type              = "ingress"

  cidr_blocks = [
    "${aws_subnet.node.*.cidr_block}",
  ]
}

// This rule allows non NLB traffic originating directly from proxies
resource "aws_security_group_rule" "auth_ingress_allow_public_traffic" {
  from_port                = 3025
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.auth.id}"
  source_security_group_id = "${aws_security_group.proxy.id}"
  to_port                  = 3025
  type                     = "ingress"
}

// All egress traffic is allowed
resource "aws_security_group_rule" "auth_egress_allow_all_traffic" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.auth.id}"
  to_port           = 0
  type              = "egress"

  cidr_blocks = [
    "0.0.0.0/0",
  ]
}

// Network load balancer for auth server.
resource "aws_lb" "auth" {
  idle_timeout       = 3600
  internal           = true
  load_balancer_type = "network"
  name               = "${var.cluster_name}-auth"
  tags               = "${local.default_tags}"

  subnets = [
    "${aws_subnet.public.*.id}",
  ]
}

// Target group is associated with auto scale group
resource "aws_lb_target_group" "auth" {
  name     = "${var.cluster_name}-auth"
  port     = 3025
  protocol = "TCP"
  tags     = "${local.default_tags}"
  vpc_id   = "${aws_vpc.teleport.id}"
}

// 3025 is the Auth servers API server listener.
resource "aws_lb_listener" "auth" {
  load_balancer_arn = "${aws_lb.auth.arn}"
  port              = "3025"
  protocol          = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.auth.arn}"
    type             = "forward"
  }
}
