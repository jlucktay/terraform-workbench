resource "aws_iam_role" "main" {
  name = "james.lucktaylor.awscda.iam.ec2"
}

# resource "aws_iam_service_linked_role" "main" {
#   aws_service_name = "ec2.amazonaws.com"
# }
