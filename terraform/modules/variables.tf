variable "environment" {
  type        = string
  description = "The deployment environment (e.g., dev, test, demo, prod)."
}

variable "app_name" {
  type        = string
  description = "The name of the application, used for resource naming and tagging."
}

variable "dns_name" {
  type        = string
  description = "The fully qualified domain name (FQDN) for the CloudFront distribution aliases."
}

variable "hosted_zone_id" {
  type        = string
  description = "Hosted zone id of the domain"
}