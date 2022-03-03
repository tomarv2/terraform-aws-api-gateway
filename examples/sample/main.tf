terraform {
  required_version = ">= 1.0.1"
  required_providers {
    aws = {
      version = "~> 3.63"
    }
  }
}

provider "aws" {
  region  = "us-west-2"
  profile = "default"
}


module "api_gateway" {
  source = "../../"

  teamid = var.teamid
  prjid  = var.prjid

  function_name = "rumse-demo"
  stage_name    = "dev"
  api_cname     = "cicd"
  domain_name   = "test.demo.com"
  names = [
  "tryme"]
  types_of_records = [
  "CNAME"]
}
