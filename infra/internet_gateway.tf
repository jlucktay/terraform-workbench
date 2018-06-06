resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags = "${
    merge(
      local.default-tags,
      map(
        "Name", "james.lucktaylor.igw",
      )
    )
  }"
}
