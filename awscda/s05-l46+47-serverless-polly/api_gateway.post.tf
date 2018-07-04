resource "aws_api_gateway_method" "polly_post" {
  authorization = "NONE"
  http_method   = "POST"
  rest_api_id   = "${aws_api_gateway_rest_api.polly.id}"
  resource_id   = "${aws_api_gateway_resource.polly.id}"
}

resource "aws_api_gateway_method_response" "polly_post" {
  http_method = "${aws_api_gateway_method.polly_post.http_method}"
  resource_id = "${aws_api_gateway_resource.polly.id}"
  rest_api_id = "${aws_api_gateway_rest_api.polly.id}"
  status_code = "200"

  response_models {
    "application/json" = "Empty"
  }

  response_parameters {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration" "polly_post" {
  http_method             = "${aws_api_gateway_method.polly_post.http_method}"
  integration_http_method = "POST"
  resource_id             = "${aws_api_gateway_resource.polly.id}"
  rest_api_id             = "${aws_api_gateway_rest_api.polly.id}"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${aws_lambda_function.polly_new_post.arn}/invocations"
}

resource "aws_api_gateway_integration_response" "polly_post" {
  http_method = "${aws_api_gateway_method.polly_post.http_method}"
  resource_id = "${aws_api_gateway_resource.polly.id}"
  rest_api_id = "${aws_api_gateway_rest_api.polly.id}"
  status_code = "${aws_api_gateway_method_response.polly_post.status_code}"

  response_parameters {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}
