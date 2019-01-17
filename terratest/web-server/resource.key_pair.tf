resource "aws_key_pair" "my-public-key" {
  key_name   = "james.lucktaylor.${var.aws_region}"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}
