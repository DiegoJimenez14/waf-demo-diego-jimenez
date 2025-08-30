variable "project" {
  type        = string
  description = "Nombre del proyecto"
  default     = "ecommerce-waf"
}

variable "environment" {
  type        = string
  description = "Entorno (dev|stg|prod)"
  default     = "dev"
}
