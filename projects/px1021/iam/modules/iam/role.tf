resource "aws_iam_role" "this" {
  assume_role_policy = "${data.aws_iam_policy_document.assume-role.json}"
  count              = "${null_resource.roles.count}"
  name               = "${element(null_resource.roles.*.triggers.name, count.index)}"
}

### Will need something like this later, once we figure out which policies to attach to what
# resource "aws_iam_role_policy_attachment" "something" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
#   role       = "${aws_iam_role.this.name}"
# }
