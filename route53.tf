module "route53" {
  source = "git@github.com:tomarv2/terraform-aws-route53.git?ref=v0.0.10"

  deploy_route53 = var.deploy_route53

  domain_name      = var.domain_name
  names            = var.names
  types_of_records = var.types_of_records
  ttls             = var.ttls
  values           = var.values != null ? var.values : [join("", aws_api_gateway_domain_name.domain_name.*.regional_domain_name)]
  # ---------------------------------------------
  # Note: Do not change teamid and prjid once set.
  teamid = var.teamid
  prjid  = var.prjid
}
