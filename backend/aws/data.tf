data "aws_region" "current" {}

data "template_file" "policy" {
  template = "${file("${path.module}/s3.policy.json")}"

  vars {
    state_bucket = "${var.state_bucket}"
  }
}
