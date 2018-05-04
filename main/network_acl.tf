resource "aws_network_acl" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags = "${merge(
    local.default-tags,
    map(
      "Name", "james.lucktaylor.acl"
    )
  )}"
}
