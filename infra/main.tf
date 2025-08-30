module "waf_cloudfront" {
  source              = "./modules/waf"
  name                = "${var.project}-${var.environment}-cf"
  scope               = "CLOUDFRONT"
  enable_bot_control  = true
  enable_acfp         = false   # activaremos cuando definamos /signup
  enable_atp          = false   # activaremos cuando definamos /login
  log_retention_days  = 30
  rate_limit_per_5m   = 2000
  captcha_paths       = ["/login", "/signup", "/register", "/checkout"]
}

output "waf_cloudfront_arn" {
  value = module.waf_cloudfront.web_acl_arn
}

