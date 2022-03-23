locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name

  api_gateway_name = var.api_gateway_name != null ? var.api_gateway_name : "${var.teamid}-${var.prjid}"
  stage_name       = var.stage_name != null ? var.stage_name : "${var.teamid}-${var.prjid}"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}
