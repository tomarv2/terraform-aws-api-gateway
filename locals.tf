locals {
  shared_tags = tomap(
    {
      "Name"    = "${var.teamid}-${var.prjid}",
      "team"    = var.teamid,
      "project" = var.prjid
    }
  )

  api_gateway_name = var.api_gateway_name != null ? var.api_gateway_name : "${var.teamid}-${var.prjid}"
  stage_name       = var.stage_name != null ? var.stage_name : "${var.teamid}-${var.prjid}"
}

data "aws_caller_identity" "current" {}

data "aws_acm_certificate" "cert" {
  count = var.deploy_api_gateway ? 1 : 0

  domain      = "*.${var.domain_name}"
  statuses    = ["ISSUED"]
  most_recent = true
}
