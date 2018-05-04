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

resource "aws_s3_bucket_policy" "backend" {
  bucket = "${aws_s3_bucket.state-storage.id}"
  policy = "${file("s3.policy.json")}"
}
