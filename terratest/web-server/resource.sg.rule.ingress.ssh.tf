resource "aws_security_group_rule" "allow_ingress_ssh" {
  security_group_id = "${aws_security_group.web_server.id}"
  description       = "SSH from everywhere"

  type = "ingress"

  from_port = 22
  to_port   = 22
  protocol  = "tcp"

  cidr_blocks = [
    "${data.external.ip.result.ip}/32",
  ]
}
