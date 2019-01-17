resource "aws_security_group" "web_server" {
  name                   = "web_server"
  description            = "Access to port 8080 from Cloudreach London office"
  revoke_rules_on_delete = true
  vpc_id                 = "${aws_vpc.main.id}"
}
