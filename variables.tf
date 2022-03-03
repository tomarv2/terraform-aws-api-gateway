variable "teamid" {
  description = "Name of the team/group e.g. devops, dataengineering. Should not be changed after running 'tf apply'"
  type        = string
}

variable "prjid" {
  description = "Name of the project/stack e.g: mystack, nifieks, demoaci. Should not be changed after running 'tf apply'"
  type        = string
}


variable "function_name" {
  description = "Lambda"
  type        = string
}

variable "method" {
  description = "API method"
  default     = "POST"
  type        = string
}

variable "path" {
  description = "API path"
  default     = "/"
  type        = string
}

variable "api_gateway_name" {
  description = "API gateway name"
  default     = null
  type        = string
}

variable "status_code" {
  description = "Status code"
  default     = "200"
  type        = string
}

variable "stage_name" {
  description = "Stage name"
  default     = null
  type        = string
}

variable "domain_name" {
  description = "Domain Name"
  type        = string
}

variable "api_cname" {
  description = "DNS Cname for API Gateway"
  type        = string
}

variable "types_of_records" {
  type        = list(any)
  description = "The record type. Valid values are A, AAAA, CAA, CNAME, MX, NAPTR, NS, PTR, SOA, SPF, SRV and TXT. "
}

variable "ttls" {
  type        = list(any)
  default     = ["3600"]
  description = "(Required for non-alias records) The TTL of the record."
}

variable "names" {
  type        = list(any)
  description = "The name of the record."
}

variable "values" {
  type        = list(any)
  default     = null
  description = "(Required for non-alias records) A string list of records. To specify a single record value longer than 255 characters such as a TXT record for DKIM, add \"\" inside the Terraform configuration string (e.g. \"first255characters\"\"morecharacters\")."
}

variable "cloudwatch_path" {
  description = "Cloudwatch path"
  type        = string
  default     = null
}

variable "cache_cluster_size" {
  description = "Cache Cluster size"
  type        = string
  default     = "0.5"
}

variable "throttling_burst_limit" {
  description = "Throttling burst limit"
  type        = string
  default     = "50"
}

variable "throttling_rate_limit" {
  description = "Throttling rate limit"
  type        = string
  default     = "100"
}

variable "disable_execute_api_endpoint" {
  description = "Disable execute api endpoint"
  type        = string
  default     = false
}

variable "integration_type" {
  type        = string
  default     = "AWS_PROXY"
  description = "The integration input's type. Valid values are HTTP (for HTTP backends), MOCK (not calling any real backend), AWS (for AWS services), AWS_PROXY (for Lambda proxy integration) and HTTP_PROXY (for HTTP proxy integration)."
}

variable "deploy_route53" {
  type        = bool
  default     = true
  description = "feature flag, true or false"
}

variable "deploy_cloudwatch" {
  description = "feature flag, true or false"
  default     = true
  type        = bool
}

variable "deploy_api_gateway" {
  description = "feature flag, true or false"
  default     = true
  type        = bool
}

variable "description" {
  description = "API Gateway description"
  default     = null
  type        = string
}
