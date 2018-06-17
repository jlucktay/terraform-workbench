resource "aws_s3_bucket" "serverless-website" {
  bucket = "james-lucktaylor-awscda-serverless-website"
  region = "${var.region}"

  tags = "${
    merge(
      local.default-tags,
      map(
        "Name", "james-lucktaylor-serverless-website",
      )
    )
  }"

  website {
    error_document = "error.html"
    index_document = "index.html"
  }
}
