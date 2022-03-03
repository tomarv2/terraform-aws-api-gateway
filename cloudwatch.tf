module "cloudwatch" {
  source = "git::git@github.com:tomarv2/terraform-aws-cloudwatch.git?ref=v0.0.7"

  deploy_cloudwatch = var.deploy_cloudwatch

  cloudwatch_path = var.cloudwatch_path != null ? var.cloudwatch_path : "/aws/apigateway"
  teamid          = var.teamid
  prjid           = var.prjid
}
