resource "aws_iam_role" "this" {
  assume_role_policy = "${data.aws_iam_policy_document.assume-role.json}"
  count              = "${null_resource.roles.count}"
  name               = "${element(null_resource.roles.*.triggers.name, count.index)}"
}

# resource "aws_iam_role_policy_attachment" "s3" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
#   role       = "${aws_iam_role.main.name}"
# }
