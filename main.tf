resource "aws_api_gateway_rest_api" "api_gateway_rest_api" {
  count = var.deploy_api_gateway ? 1 : 0

  name        = local.api_gateway_name
  description = var.description != null ? var.description : "Terraform managed: API Gateway"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
  disable_execute_api_endpoint = var.disable_execute_api_endpoint

  tags = merge(local.shared_tags)
}

/*
resource "aws_api_gateway_rest_api_policy" "gimme_creds_policy" {
  depends_on  = [aws_api_gateway_rest_api.gimme_creds_api]
  rest_api_id = aws_api_gateway_rest_api.gimme_creds_api.id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : "*",
          "Action" : "execute-api:Invoke",
          "Resource" : "${aws_api_gateway_rest_api.gimme_creds_api.execution_arn}/${var.env}/GET/",
          "Condition" : {
            "IpAddress" : {
              "aws:SourceIp" : var.allowed_ip_ranges
            }
          }
        }
      ]
    }
  )
}
*/

resource "aws_api_gateway_method" "gateway_method" {
  count = var.deploy_api_gateway ? 1 : 0

  authorization = "NONE"
  http_method   = var.method
  resource_id   = join("", aws_api_gateway_rest_api.api_gateway_rest_api.*.root_resource_id)
  rest_api_id   = join("", aws_api_gateway_rest_api.api_gateway_rest_api.*.id)
}

resource "aws_api_gateway_integration" "request_method_integration" {
  count = var.deploy_api_gateway ? 1 : 0

  resource_id = join("", aws_api_gateway_rest_api.api_gateway_rest_api.*.root_resource_id)
  rest_api_id = join("", aws_api_gateway_rest_api.api_gateway_rest_api.*.id)
  http_method = join("", aws_api_gateway_method.gateway_method.*.http_method)
  type        = var.integration_type
  uri         = "arn:aws:apigateway:${local.region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${local.region}:${local.account_id}:function:${var.function_name}/invocations"
  # AWS lambdas can only be invoked with the POST method
  integration_http_method = var.method
  request_templates = {
    "application/json" = file("${path.module}/api_gateway_body_mapping.tpl")
  }
}
resource "aws_api_gateway_method_response" "response_method" {
  count = var.deploy_api_gateway ? 1 : 0

  resource_id = join("", aws_api_gateway_rest_api.api_gateway_rest_api.*.root_resource_id)
  rest_api_id = join("", aws_api_gateway_rest_api.api_gateway_rest_api.*.id)
  http_method = join("", aws_api_gateway_method.gateway_method.*.http_method)
  status_code = var.status_code
  response_models = {
    "application/json" = "Empty"
  }
}
resource "aws_api_gateway_integration_response" "response_method_integration" {
  count = var.deploy_api_gateway ? 1 : 0

  resource_id = join("", aws_api_gateway_rest_api.api_gateway_rest_api.*.root_resource_id)
  rest_api_id = join("", aws_api_gateway_rest_api.api_gateway_rest_api.*.id)
  http_method = join("", aws_api_gateway_method.gateway_method.*.http_method)
  status_code = join("", aws_api_gateway_method_response.response_method.*.status_code)
  response_templates = {
    "application/json" = ""
  }
}
resource "aws_lambda_permission" "allow_api_gateway" {
  count = var.deploy_api_gateway ? 1 : 0

  function_name = var.function_name
  statement_id  = "${var.teamid}-${var.prjid}-AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${local.region}:${local.account_id}:${join("", aws_api_gateway_rest_api.api_gateway_rest_api.*.id)}/*/${var.method}${var.path}"
}

resource "aws_api_gateway_deployment" "gateway_deployment" {
  #count = var.deploy_api_gateway ? 1 : 0 TODO

  rest_api_id = join("", aws_api_gateway_rest_api.api_gateway_rest_api.*.id)
  variables = {
    deployed_at = timestamp()
  }
  description = var.description != null ? var.description : "Terraform managed: API Gateway"

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_api_gateway_integration.request_method_integration]
}

resource "aws_api_gateway_stage" "gateway_stage" {
  count = var.deploy_api_gateway ? 1 : 0

  deployment_id      = aws_api_gateway_deployment.gateway_deployment.id
  rest_api_id        = join("", aws_api_gateway_rest_api.api_gateway_rest_api.*.id)
  stage_name         = local.stage_name
  description        = var.description != null ? var.description : "Terraform managed: API Gateway"
  cache_cluster_size = var.cache_cluster_size
  tags               = merge(local.shared_tags)

  access_log_settings {
    destination_arn = module.cloudwatch.log_group_arn
    format = jsonencode(
      {
        caller         = "$context.identity.caller"
        httpMethod     = "$context.httpMethod"
        ip             = "$context.identity.sourceIp"
        protocol       = "$context.protocol"
        requestId      = "$context.requestId"
        requestTime    = "$context.requestTime"
        resourcePath   = "$context.resourcePath"
        responseLength = "$context.responseLength"
        status         = "$context.status"
        user           = "$context.identity.user"
      }
    )
  }
  depends_on = [module.cloudwatch]
}

resource "aws_api_gateway_method_settings" "method_settings" {
  count = var.deploy_api_gateway ? 1 : 0

  rest_api_id = join("", aws_api_gateway_rest_api.api_gateway_rest_api.*.id)
  stage_name  = join("", aws_api_gateway_stage.gateway_stage.*.stage_name)
  method_path = "*/*"

  settings {
    metrics_enabled        = true
    logging_level          = "INFO"
    throttling_burst_limit = var.throttling_burst_limit
    throttling_rate_limit  = var.throttling_rate_limit
  }
}

# API Gateway Custom Domain Name
resource "aws_api_gateway_domain_name" "domain_name" {
  count = var.deploy_api_gateway ? 1 : 0

  regional_certificate_arn = join("", data.aws_acm_certificate.cert.*.id)
  domain_name              = "${var.api_cname}.${var.domain_name}"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
  security_policy = "TLS_1_2"

  depends_on = [aws_api_gateway_rest_api.api_gateway_rest_api]
}

# API Gateway Custom Domain Name path
resource "aws_api_gateway_base_path_mapping" "cname_deployed_path" {
  count = var.deploy_api_gateway ? 1 : 0

  api_id      = join("", aws_api_gateway_rest_api.api_gateway_rest_api.*.id)
  stage_name  = aws_api_gateway_deployment.gateway_deployment.stage_name
  domain_name = join("", aws_api_gateway_domain_name.domain_name.*.domain_name)

  depends_on = [aws_api_gateway_domain_name.domain_name, aws_api_gateway_deployment.gateway_deployment]
}
