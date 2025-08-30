# Log group para almacenar logs del WAF
resource "aws_cloudwatch_log_group" "waf" {
  name              = "/aws/waf/${var.name}"
  retention_in_days = var.log_retention_days
}

# Web ACL principal (versión reducida para validar)
resource "aws_wafv2_web_acl" "this" {
  name  = var.name
  scope = var.scope

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.name}-metrics"
    sampled_requests_enabled   = true
  }

  # Regla 1: Common Rule Set
  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 10
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "CommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  # Regla 2: Known Bad Inputs
  rule {
    name     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
    priority = 20
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "KnownBadInputs"
      sampled_requests_enabled   = true
    }
  }

  # Regla 3: IP Reputation
  rule {
    name     = "AWS-AWSManagedRulesAmazonIpReputationList"
    priority = 30
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "IPReputation"
      sampled_requests_enabled   = true
    }
  }

  # Regla 4: Anonymous IP List
  rule {
    name     = "AWS-AWSManagedRulesAnonymousIpList"
    priority = 40
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAnonymousIpList"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AnonymousIP"
      sampled_requests_enabled   = true
    }
  }

  # Regla 5: SQL Injection
  rule {
    name     = "AWS-AWSManagedRulesSQLiRuleSet"
    priority = 50
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "SQLi"
      sampled_requests_enabled   = true
    }
  }
  # Regla 6: Cross-Site Scripting (XSS)
  rule {
    name     = "AWS-AWSManagedRulesCrossSiteScriptingRuleSet"
    priority = 60
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCrossSiteScriptingRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "XSS"
      sampled_requests_enabled   = true
    }
  }

  # Reglas dinámicas de CAPTCHA en rutas críticas
  dynamic "rule" {
    for_each = toset(var.captcha_paths)
    content {
      name     = "CaptchaPath-${replace(rule.value, "/", "_")}"
      priority = 100 + index(var.captcha_paths, rule.value)
      action {
        captcha {}
      }
      statement {
        byte_match_statement {
          search_string = rule.value
          field_to_match {
            uri_path {}
          }
          positional_constraint = "STARTS_WITH"
          text_transformation {
            priority = 0
            type     = "NONE"
          }
        }
      }
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "CaptchaPath-${replace(rule.value, "/", "_")}"
        sampled_requests_enabled   = true
      }
    }
  }

  # Regla 7: Rate limit por IP
  rule {
    name     = "RateLimitPerIP"
    priority = 200
    action {
      block {}
    }
    statement {
      rate_based_statement {
        limit              = var.rate_limit_per_5m
        aggregate_key_type = "IP"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimitPerIP"
      sampled_requests_enabled   = true
    }
  }
}
# Logging WAF -> CloudWatch Logs
resource "aws_wafv2_web_acl_logging_configuration" "log" {
  resource_arn            = aws_wafv2_web_acl.this.arn
  log_destination_configs = [aws_cloudwatch_log_group.waf.arn]

  redacted_fields {
    single_header { name = "authorization" }
  }

  redacted_fields {
    single_header { name = "cookie" }
  }
}
