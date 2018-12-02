resource "aws_network_interface_sg_attachment" "awscda-dmz" {
  count                = "${aws_instance.awscda.count}"
  network_interface_id = "${element(aws_instance.awscda.*.primary_network_interface_id, count.index)}"
  security_group_id    = "${data.aws_security_group.dmz.id}"
}
