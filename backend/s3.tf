resource "aws_s3_bucket" "state-storage" {
  acl           = "private"
  bucket        = "james-lucktaylor-terraform"
  force_destroy = false
  region        = "${data.aws_region.current.name}"

  tags = "${
    merge(
      local.default-tags,
      map(
        "Name", "james-lucktaylor-terraform",
      )
    )
  }"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_policy" "state-storage" {
  bucket = "${aws_s3_bucket.state-storage.id}"
  policy = "${file("s3.policy.json")}"
}
