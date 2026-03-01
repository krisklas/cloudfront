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

variable "certificate_arn" {
  type        = string
  description = "The ARN of the ACM certificate to be used for the CloudFront distribution."
}