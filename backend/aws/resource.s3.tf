resource "aws_s3_bucket" "state-storage" {
  acl           = "private"
  bucket        = "${var.state_bucket}"
  force_destroy = false
  region        = "${data.aws_region.current.name}"

  tags = {
    Name = "${var.state_bucket}"
  }

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
  policy = "${data.template_file.policy.rendered}"
}
