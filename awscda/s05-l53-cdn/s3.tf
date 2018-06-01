resource "aws_s3_bucket" "london" {
  bucket   = "james-lucktaylor-cdn-london"
  provider = "aws.london"
  region   = "eu-west-2"

  tags = "${merge(
    local.default-tags,
    map(
      "Name", "james-lucktaylor-cdn-london",
    )
  )}"
}

resource "aws_s3_bucket" "sydney" {
  bucket   = "james-lucktaylor-cdn-sydney"
  provider = "aws.sydney"
  region   = "ap-southeast-2"

  tags = "${merge(
    local.default-tags,
    map(
      "Name", "james-lucktaylor-cdn-sydney",
    )
  )}"
}
