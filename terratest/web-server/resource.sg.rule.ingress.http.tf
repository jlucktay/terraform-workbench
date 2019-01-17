resource "aws_security_group_rule" "allow_ingress_http" {
  security_group_id = "${aws_security_group.web_server.id}"
  description       = "HTTP from everywhere"

  type = "ingress"

  from_port = 8080
  to_port   = 8080
  protocol  = "tcp"

  cidr_blocks = [
    "${data.external.ip.result.ip}/32",
  ]
}
