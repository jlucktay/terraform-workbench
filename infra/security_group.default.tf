resource "aws_security_group" "default" {
  description            = "default VPC security group"
  name                   = "default"
  revoke_rules_on_delete = true
  vpc_id                 = "${aws_vpc.main.id}"

  tags = "${merge(
    local.default-tags,
    map("Name", "james.lucktaylor.sg.default")
  )}"
}

resource "aws_security_group_rule" "default-allow-http-from-everywhere" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "HTTP from everywhere"
  from_port         = 80
  protocol          = "tcp"
  security_group_id = "${aws_security_group.default.id}"
  to_port           = 80
  type              = "ingress"
}

resource "aws_security_group_rule" "default-allow-all-from-self" {
  description       = "All from self"
  from_port         = -1
  protocol          = "all"
  security_group_id = "${aws_security_group.default.id}"
  self              = true
  to_port           = -1
  type              = "ingress"
}

resource "aws_security_group_rule" "default-allow-all-to-everywhere" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "All to everywhere"
  from_port         = -1
  protocol          = "all"
  security_group_id = "${aws_security_group.default.id}"
  to_port           = -1
  type              = "egress"
}
