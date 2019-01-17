resource "aws_subnet" "main" {
  cidr_block = "10.0.0.0/24"
  vpc_id     = "${aws_vpc.main.id}"
}
