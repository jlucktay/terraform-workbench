output "lambda-invocation-url" {
  value = "${aws_api_gateway_deployment.serverless.invoke_url}/${aws_api_gateway_resource.serverless.path_part}"
}

output "s3-url" {
  value = "http://${aws_s3_bucket.serverless-website.website_endpoint}"
}
