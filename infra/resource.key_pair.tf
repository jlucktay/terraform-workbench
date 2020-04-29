resource "aws_key_pair" "my-public-key" {
  key_name   = "james.lucktaylor.${var.region}"
  public_key = file("~/.ssh/id_rsa.pub")
}

# TODO: set up keys across multiple regions
#       - with different providers?
