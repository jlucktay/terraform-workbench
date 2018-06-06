resource "aws_key_pair" "eu-west-1" {
  key_name   = "james.lucktaylor.eu-west-1"
  public_key = "${file("james.lucktaylor.eu-west-1.pub")}"
}

# TODO: set up keys across multiple regions
#       - with different providers?
