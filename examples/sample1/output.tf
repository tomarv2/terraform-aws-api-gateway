output "api_gateway_name" {
  description = "API Gateway name"
  value       = module.api_gateway.api_gateway_name
}

output "api_gateway_arn" {
  description = "API Gateway arn"
  value       = module.api_gateway.api_gateway_arn
}

output "cname" {
  description = "API Gateway cname"
  value       = module.api_gateway.cname
}

output "cloudwatch_log_group_arn" {
  description = "Cloudwatch log group arn."
  value       = module.api_gateway.cloudwatch_log_group_arn
}
