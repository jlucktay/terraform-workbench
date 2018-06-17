resource "aws_s3_bucket" "website-index" {
  bucket = "james-lucktaylor-website-index"
  region = "${var.region}"

  tags = "${
    merge(
      local.default-tags,
      map(
        "Name", "james-lucktaylor-website-index",
      )
    )
  }"

  website {
    error_document = "error.html"
    index_document = "index.html"
  }
}

resource "aws_s3_bucket" "website-cors" {
  bucket = "james-lucktaylor-website-cors"
  region = "${var.region}"

  tags = "${
    merge(
      local.default-tags,
      map(
        "Name", "james-lucktaylor-website-cors",
      )
    )
  }"

  website {
    index_document = ""
  }
}
