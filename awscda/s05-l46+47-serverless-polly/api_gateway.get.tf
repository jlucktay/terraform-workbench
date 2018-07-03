resource "aws_api_gateway_method" "polly_get" {
  authorization = "NONE"
  http_method   = "GET"
  rest_api_id   = "${aws_api_gateway_rest_api.polly.id}"
  resource_id   = "${aws_api_gateway_resource.polly.id}"
}

resource "aws_api_gateway_integration" "polly_get" {
  http_method             = "${aws_api_gateway_method.polly_get.http_method}"
  integration_http_method = "POST"
  resource_id             = "${aws_api_gateway_resource.polly.id}"
  rest_api_id             = "${aws_api_gateway_rest_api.polly.id}"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${aws_lambda_function.polly_get_posts.arn}/invocations"
}

resource "aws_api_gateway_method_response" "polly_get" {
  http_method = "${aws_api_gateway_method.polly_get.http_method}"
  resource_id = "${aws_api_gateway_resource.polly.id}"
  rest_api_id = "${aws_api_gateway_rest_api.polly.id}"
  status_code = "200"

  response_models {
    "application/json" = "Empty"
  }
}
