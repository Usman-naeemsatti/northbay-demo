resource "aws_api_gateway_rest_api" "my_api" {
  name = "my-api"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "root_resource" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part = "data"
}

resource "aws_api_gateway_method" "my_method" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.root_resource.id  # Reference the resource ID
  http_method = "POST"  # You can adjust the HTTP method (e.g., POST, PUT)
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.root_resource.id
  http_method = aws_api_gateway_method.my_method.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration" "post_method_integration" {
  rest_api_id             = aws_api_gateway_rest_api.my_api.id
  resource_id             = aws_api_gateway_resource.root_resource.id
  http_method             = aws_api_gateway_method.my_method.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri = "arn:aws:apigateway:${var.default_region}:kinesis:action/PutRecord"
  credentials = aws_iam_role.api_gw_kinesis_role.arn

}

resource "aws_api_gateway_deployment" "prod" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  stage_name = "prod" # You can customize the stage name

  depends_on = [
        aws_api_gateway_method.my_method,
        aws_api_gateway_integration.post_method_integration
      ]
}
