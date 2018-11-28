resource "aws_network_interface_sg_attachment" "awscda-dmz" {
  network_interface_id = "${aws_instance.awscda.primary_network_interface_id}"
  security_group_id    = "${data.aws_security_group.dmz.id}"
}
