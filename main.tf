terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-1"
}

resource "aws_wafv2_web_acl" "waf_acl" {
  depends_on = [
    aws_waf_xss_match_set.xss,
    aws_waf_rule.wafrule,
  ]
  name        = "tfWebACL"

  default_action {
    allow {}
  }

  rule {
  
  }

  scope = "REGIONAL"

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name = "tfWebACL"
    sampled_requests_enabled = true
  }

}
