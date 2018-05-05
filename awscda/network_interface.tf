resource "aws_network_interface" "awscda" {
  description = "Primary network interface"
  subnet_id   = "${aws_instance.awscda.subnet_id}"

  tags = "${merge(
    local.default-tags,
    map(
      "Name", "james.lucktaylor.nic.awscda"
    )
  )}"
}

resource "aws_network_interface_attachment" "awscda" {
  device_index         = 0
  instance_id          = "${aws_instance.awscda.id}"
  network_interface_id = "${aws_network_interface.awscda.id}"
}

resource "aws_network_interface_sg_attachment" "awscda-dmz" {
  network_interface_id = "${aws_network_interface.awscda.id}"
  security_group_id    = "${aws_security_group.dmz.id}"
}
