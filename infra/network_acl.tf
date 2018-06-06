resource "aws_default_network_acl" "main" {
  default_network_acl_id = "${aws_vpc.main.default_network_acl_id}"
  subnet_ids             = ["${aws_subnet.main.*.id}"]

  tags = "${
    merge(
      local.default-tags,
      map(
        "Name", "james.lucktaylor.acl",
      )
    )
  }"

  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    protocol   = -1
    rule_no    = 100
    to_port    = 0
  }

  ingress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    protocol   = -1
    rule_no    = 100
    to_port    = 0
  }
}
