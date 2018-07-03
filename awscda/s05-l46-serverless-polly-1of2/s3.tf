resource "aws_s3_bucket" "polly_website" {
  acl           = "private"
  bucket        = "james.lucktaylor.awscda.polly.website"
  force_destroy = true
  region        = "${data.aws_region.current.name}"

  tags = "${merge(
    local.default-tags,
    map(
      "Name", "james.lucktaylor.awscda.polly.website",
    )
  )}"
}

resource "aws_s3_bucket" "polly_mp3s" {
  acl           = "private"
  bucket        = "james.lucktaylor.awscda.polly.mp3s"
  force_destroy = true
  region        = "${data.aws_region.current.name}"

  tags = "${merge(
    local.default-tags,
    map(
      "Name", "james.lucktaylor.awscda.polly.mp3s",
    )
  )}"
}
