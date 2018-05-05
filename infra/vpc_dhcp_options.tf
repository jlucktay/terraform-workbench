resource "aws_vpc_dhcp_options" "main" {
  domain_name         = "${data.aws_region.current.name}.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = "${merge(
    local.default-tags,
    map(
      "Name", "james.lucktaylor.dopt"
    )
  )}"
}

resource "aws_vpc_dhcp_options_association" "main" {
  dhcp_options_id = "${aws_vpc_dhcp_options.main.id}"
  vpc_id          = "${aws_vpc.main.id}"
}
