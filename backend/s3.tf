resource "aws_s3_bucket" "state-storage" {
  acl    = "private"
  bucket = "james-lucktaylor-terraform"
  region = "${data.aws_region.current.name}"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

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
