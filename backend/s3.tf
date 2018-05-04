resource "aws_s3_bucket" "state-storage" {
  acl    = "private"
  bucket = "james-lucktaylor-terraform"
  region = "${data.aws_region.current.name}"

  tags {
    Owner = "james.lucktaylor"
  }

  versioning {
    enabled = true
  }
}
