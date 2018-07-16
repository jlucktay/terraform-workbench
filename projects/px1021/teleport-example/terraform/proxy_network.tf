// Proxy is deployed in public subnet to receive traffic from Network load balancers.
resource "aws_security_group" "proxy" {
  name   = "${var.cluster_name}-proxy"
  tags   = "${local.default_tags}"
  vpc_id = "${local.vpc_id}"
}

// SSH emergency access via bastion only
resource "aws_security_group_rule" "proxy_ingress_allow_ssh" {
  from_port                = 22
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.proxy.id}"
  to_port                  = 22
  type                     = "ingress"
  source_security_group_id = "${aws_security_group.bastion.id}"
}

// Ingress proxy traffic is allowed from all ports
resource "aws_security_group_rule" "proxy_ingress_allow_proxy" {
  from_port         = 3023
  protocol          = "tcp"
  security_group_id = "${aws_security_group.proxy.id}"
  to_port           = 3023
  type              = "ingress"

  cidr_blocks = [
    "0.0.0.0/0",
  ]
}

// Ingress traffic to web port 3080 is allowed from all directions
resource "aws_security_group_rule" "proxy_ingress_allow_web" {
  from_port         = 3080
  protocol          = "tcp"
  security_group_id = "${aws_security_group.proxy.id}"
  to_port           = 3080
  type              = "ingress"

  cidr_blocks = [
    "0.0.0.0/0",
  ]
}

// Egress traffic is allowed everywhere
resource "aws_security_group_rule" "proxy_egress_allow_all_traffic" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.proxy.id}"
  to_port           = 0
  type              = "egress"

  cidr_blocks = [
    "0.0.0.0/0",
  ]
}

// Load balancer for proxy server
resource "aws_lb" "proxy" {
  idle_timeout       = 3600
  internal           = false
  load_balancer_type = "network"
  name               = "${var.cluster_name}-proxy"
  tags               = "${local.default_tags}"

  depends_on = [
    "aws_internet_gateway.teleport",
  ]

  subnets = [
    "${aws_subnet.public.*.id}",
  ]
}

// Proxy is for SSH proxy - jumphost target endpoint.
resource "aws_lb_target_group" "proxy_proxy" {
  name     = "${var.cluster_name}-proxy-proxy"
  port     = 3023
  protocol = "TCP"
  tags     = "${local.default_tags}"
  vpc_id   = "${aws_vpc.teleport.id}"
}

resource "aws_lb_listener" "proxy_proxy" {
  load_balancer_arn = "${aws_lb.proxy.arn}"
  port              = "3023"
  protocol          = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.proxy_proxy.arn}"
    type             = "forward"
  }
}

// This is address used for remote clusters to connect to and the users accessing web UI.
resource "aws_lb_target_group" "proxy_web" {
  name     = "${var.cluster_name}-proxy-web"
  port     = 3080
  protocol = "TCP"
  tags     = "${local.default_tags}"
  vpc_id   = "${aws_vpc.teleport.id}"
}

resource "aws_lb_listener" "proxy_web" {
  load_balancer_arn = "${aws_lb.proxy.arn}"
  port              = "443"
  protocol          = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.proxy_web.arn}"
    type             = "forward"
  }
}

// This is a small hack to expose grafana over web port 8443
// feel free to remove it or replace with something else
resource "aws_lb_target_group" "proxy_grafana" {
  name     = "${var.cluster_name}-proxy-grafana"
  port     = 8443
  protocol = "TCP"
  tags     = "${local.default_tags}"
  vpc_id   = "${aws_vpc.teleport.id}"
}

resource "aws_lb_listener" "proxy_grafana" {
  load_balancer_arn = "${aws_lb.proxy.arn}"
  port              = "8443"
  protocol          = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.proxy_grafana.arn}"
    type             = "forward"
  }
}
