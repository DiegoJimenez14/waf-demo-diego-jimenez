variable "name" {
  type = string
}

variable "scope" {
  type        = string
  description = "CLOUDFRONT o REGIONAL"
  default     = "CLOUDFRONT"
}

variable "enable_bot_control" {
  type    = bool
  default = true
}

variable "enable_acfp" {
  type    = bool
  default = false
}

variable "enable_atp" {
  type    = bool
  default = false
}

variable "log_retention_days" {
  type    = number
  default = 30
}

variable "rate_limit_per_5m" {
  type    = number
  default = 2000
}

variable "captcha_paths" {
  type    = list(string)
  default = ["/login", "/signup", "/register"]
}
