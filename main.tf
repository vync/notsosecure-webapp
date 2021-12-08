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

resource "aws_wafv2_rule_group" "wafrulegroup" {
  capacity = 60 #followed recommendations at https://docs.aws.amazon.com/waf/latest/developerguide/waf-rule-statements-list.html
  name = "tfRuleGroup"
  scope = "REGIONAL"
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name = "tfWafRuleGroup"
    sampled_requests_enabled = true
  }

  rule {
    action {
      allow {}
    }

    name = "xss_rule1"
    priority = 1
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name = "tfWafRuleGroup_xss_rule1"
      sampled_requests_enabled = true
    }

    statement {
      not_statement {
        statement {
          xss_match_statement {
            field_to_match {
              query_string {}
            }
            text_transformation {
              priority = 1
              type = "URL_DECODE"
            }
            text_transformation {
              priority = 2
              type = "URL_DECODE_UNI"
            }
          }   
        } 
      }
    }
  }

resource "aws_wafv2_web_acl" "waf_acl" {
  depends_on = [
    #aws_waf_xss_match_set.xss,
    aws_wafv2_rule_group.wafrulegroup,
  ]
  name        = "tfWebACL"

  default_action {
    #use a default deny strategy
    block {} 
  }

  rule {
    name = "Allow non-xss matching URL queries"
    priority = 1
    statement {
      #using an AWS managed rule group here would be preferred as it takes away the maintenance burden, but for the sake of time I am collating together something which is more streamlined.
      rule_group_reference_statement {
        arn = aws_wafv2_rule_group.wafrulegroup.arn
      }
    }
  }

  scope = "REGIONAL"

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name = "tfWebACL"
    sampled_requests_enabled = true
  }
}

resource "aws_wafv2_web_acl_association" "webAclAssociation" {
  
}

resource "aws_wafv2_web_acl_logging_configuration" "webAclLoggingConfig" {
}
