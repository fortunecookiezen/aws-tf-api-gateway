# module provider requirements
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}
# module resources
# for poc this does not include logging or stuff.
resource "aws_api_gateway_rest_api" "this" {
  name = var.name
  endpoint_configuration {
    types = ["PRIVATE"]
    # vpc_endpoint_ids = []
  }
  tags = {
    Name = var.name
  }
}
resource "aws_api_gateway_resource" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "{proxy+}"
}
resource "aws_api_gateway_method" "any" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.this.id
  authorization = "NONE"
  http_method   = "ANY"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}
resource "aws_api_gateway_integration" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.this.id
  http_method = aws_api_gateway_method.any.http_method

  type = "HTTP"
  uri  = var.uri

  integration_http_method = "ANY"
  connection_type         = "VPC_LINK"
  connection_id           = aws_api_gateway_vpc_link.this.id
}
resource "aws_api_gateway_vpc_link" "this" {
  name        = var.name
  target_arns = [var.target_loadbalancer]

  tags = {
    Name = var.name
  }
}
