data "aws_acm_certificate" "cert" {
  count = var.deploy_api_gateway ? 1 : 0

  domain      = "*.${var.domain_name}"
  statuses    = ["ISSUED"]
  most_recent = true
}
