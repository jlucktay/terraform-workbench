# resource "aws_iam_role" "main" {
#   assume_role_policy = "${data.aws_iam_policy_document.ec2-assume-role-doc.json}"
#   name               = "james.lucktaylor.awscda.iam.ec2"
# }
# # resource "aws_iam_service_linked_role" "main" {
# #   aws_service_name = "ec2.amazonaws.com"
# # }
# data "aws_iam_policy_document" "ec2-assume-role-doc" {
#   statement {
#     actions = ["sts:AssumeRole"]
#     effect = "Allow"
#     principals {
#       identifiers = ["ec2.amazonaws.com"]
#       type        = "Service"
#     }
#   }
# }
