### Implementing the OPTIONS method this way enables CORS

resource "aws_api_gateway_method" "polly_options" {
  authorization = "NONE"
  http_method   = "OPTIONS"
  rest_api_id   = "${aws_api_gateway_rest_api.polly.id}"
  resource_id   = "${aws_api_gateway_resource.polly.id}"
}

resource "aws_api_gateway_method_response" "polly_options" {
  http_method = "${aws_api_gateway_method.polly_options.http_method}"
  resource_id = "${aws_api_gateway_resource.polly.id}"
  rest_api_id = "${aws_api_gateway_rest_api.polly.id}"
  status_code = "200"

  depends_on = [
    "aws_api_gateway_method.polly_options",
  ]

  response_models {
    "application/json" = "Empty"
  }

  response_parameters {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration" "polly_options" {
  http_method = "${aws_api_gateway_method.polly_options.http_method}"
  resource_id = "${aws_api_gateway_resource.polly.id}"
  rest_api_id = "${aws_api_gateway_rest_api.polly.id}"
  type        = "MOCK"
}

resource "aws_api_gateway_integration_response" "polly_options" {
  http_method = "${aws_api_gateway_method.polly_options.http_method}"
  resource_id = "${aws_api_gateway_resource.polly.id}"
  rest_api_id = "${aws_api_gateway_rest_api.polly.id}"
  status_code = "${aws_api_gateway_method_response.polly_options.status_code}"

  response_parameters {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}
