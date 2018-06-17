resource "aws_s3_bucket" "website" {
  acl    = "public-read"
  bucket = "james-lucktaylor-website"
  region = "${var.region}"

  tags = "${
    merge(
      local.default-tags,
      map(
        "Name", "james-lucktaylor-website",
      )
    )
  }"

  website {
    error_document = "error.html"
    index_document = "index.html"
  }
}
