resource "aws_security_group" "teleport-proxy" {
  description            = "Teleport proxy with access to port 3080 from everywhere"
  name                   = "james.lucktaylor.sg.teleport.proxy"
  revoke_rules_on_delete = true
  vpc_id                 = "${data.aws_vpc.main.id}"

  tags = "${
    merge(
      local.default-tags,
      map(
        "Name", "james.lucktaylor.sg.teleport.proxy",
      )
    )
  }"
}

resource "aws_security_group_rule" "teleport-allow-services-from-everywhere-ipv4" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Teleport - SSH proxy, Reverse tunnel, Auth - 3023-3025 from everywhere - IPv4"
  from_port         = 3023
  protocol          = "tcp"
  security_group_id = "${aws_security_group.teleport-proxy.id}"
  to_port           = 3025
  type              = "ingress"
}

resource "aws_security_group_rule" "teleport-allow-proxy-from-everywhere-ipv4" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Teleport - Web proxy service - 3080 from everywhere - IPv4"
  from_port         = 3080
  protocol          = "tcp"
  security_group_id = "${aws_security_group.teleport-proxy.id}"
  to_port           = 3080
  type              = "ingress"
}
