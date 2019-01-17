resource "aws_security_group" "web_server" {
  vpc_id = "${aws_vpc.main.id}"
}
