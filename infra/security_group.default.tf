resource "aws_default_security_group" "main" {
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    from_port = 0
    protocol  = -1
    self      = true
    to_port   = 0
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  tags = "${merge(
    local.default-tags,
    map("Name", "james.lucktaylor.sg.default")
  )}"
}

# resource "aws_security_group" "default" {
#   description            = "default VPC security group"
#   name                   = "default"
#   revoke_rules_on_delete = true
#   vpc_id                 = "${aws_vpc.main.id}"
# }
