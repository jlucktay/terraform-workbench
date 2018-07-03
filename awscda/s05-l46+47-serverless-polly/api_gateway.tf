resource "aws_api_gateway_rest_api" "polly" {
  description = "james.lucktaylor - Polly post reader"
  name        = "james.lucktaylor.awscda.polly"

  endpoint_configuration {
    types = ["EDGE"]
  }
}

resource "aws_api_gateway_resource" "polly" {
  parent_id   = "${aws_api_gateway_rest_api.polly.root_resource_id}"
  path_part   = "polly"
  rest_api_id = "${aws_api_gateway_rest_api.polly.id}"
}

/*
resource "aws_api_gateway_deployment" "serverless" {
  rest_api_id = "${aws_api_gateway_rest_api.serverless.id}"
  stage_name  = "prod"

  depends_on = [
    "aws_api_gateway_integration.serverless",
  ]
}
*/
