resource "aws_default_network_acl" "main" {
  default_network_acl_id = aws_vpc.main.default_network_acl_id

  subnet_ids = [
    "${aws_subnet.private.*.id}",
    "${aws_subnet.public.*.id}",
  ]

  tags = {
    Name = "james.lucktaylor.acl"
  }

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

# TODO: consider implementing a little bit more security for the private subnet somewhere around here 🤔
