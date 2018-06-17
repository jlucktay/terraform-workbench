resource "aws_s3_bucket_object" "website-index" {
  acl          = "public-read"
  bucket       = "${aws_s3_bucket.website.bucket}"
  content_type = "text/html"
  key          = "${aws_s3_bucket.website.website.0.index_document}"
  source       = "./index.html"

  tags = "${
    merge(
      local.default-tags,
    )
  }"
}

resource "aws_s3_bucket_object" "website-error" {
  acl          = "public-read"
  bucket       = "${aws_s3_bucket.website.bucket}"
  content_type = "text/html"
  key          = "${aws_s3_bucket.website.website.0.error_document}"
  source       = "./error.html"

  tags = "${
    merge(
      local.default-tags,
    )
  }"
}
