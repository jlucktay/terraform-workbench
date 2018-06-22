resource "aws_eip" "proxy" {
  vpc = true

  tags = "${
    merge(
      local.default-tags,
      map(
        "Name", "james.lucktaylor.teleport-proxy.${count.index}",
        "Purpose", "Client PoC/demo",
      )
    )
  }"
}

resource "aws_eip_association" "proxy" {
  instance_id   = "${aws_instance.teleport-proxy.id}"
  allocation_id = "${aws_eip.proxy.id}"
}
