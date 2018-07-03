/*
resource "aws_api_gateway_rest_api" "polly" {
  description = "james.lucktaylor - Polly post reader"
  name        = "james.lucktaylor.awscda.polly"

  endpoint_configuration {
    types = ["EDGE"]
  }
}

resource "aws_api_gateway_method" "serverless" {
  authorization = "NONE"
  http_method   = "GET"
  rest_api_id   = "${aws_api_gateway_rest_api.polly.id}"

  /*
  resource_id   = "${aws_api_gateway_resource.serverless.id}"
}
  */
/*
resource "aws_api_gateway_resource" "serverless" {
  parent_id   = "${aws_api_gateway_rest_api.serverless.root_resource_id}"
  path_part   = "serverlessWebsite"
  rest_api_id = "${aws_api_gateway_rest_api.serverless.id}"
}

resource "aws_api_gateway_integration" "serverless" {
  http_method             = "${aws_api_gateway_method.serverless.http_method}"
  integration_http_method = "POST"
  resource_id             = "${aws_api_gateway_resource.serverless.id}"
  rest_api_id             = "${aws_api_gateway_rest_api.serverless.id}"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${aws_lambda_function.serverless.arn}/invocations"
}

resource "aws_api_gateway_method_response" "serverless" {
  http_method = "${aws_api_gateway_method.serverless.http_method}"
  resource_id = "${aws_api_gateway_resource.serverless.id}"
  rest_api_id = "${aws_api_gateway_rest_api.serverless.id}"
  status_code = "200"

  response_models {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_deployment" "serverless" {
  rest_api_id = "${aws_api_gateway_rest_api.serverless.id}"
  stage_name  = "prod"

  depends_on = [
    "aws_api_gateway_integration.serverless",
  ]
}
*/
