output "api_gateway_name" {
  description = "API Gateway name"
  value       = join("", aws_api_gateway_rest_api.api_gateway_rest_api.*.name)
}

output "api_gateway_arn" {
  description = "API Gateway arn"
  value       = join("", aws_api_gateway_rest_api.api_gateway_rest_api.*.arn)
}

output "cname" {
  description = "API Gateway cname"
  value       = module.route53.route53_fdqn
}

output "cloudwatch_log_group_arn" {
  description = "Cloudwatch log group arn."
  value       = module.cloudwatch.log_group_arn
}
