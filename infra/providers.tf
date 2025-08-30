variable "aws_region" {
  type        = string
  description = "Región para recursos; WAF para CloudFront requiere us-east-1"
  default     = "us-east-1"
}

provider "aws" {
  region = var.aws_region
}
