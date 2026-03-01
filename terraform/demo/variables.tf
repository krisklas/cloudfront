variable "hosted_zone_name" {
  type        = string
  default     = "demo.domain.com"
  description = "Name of the hosted zone to deploy to."
}

variable "domain_name_prefix" {
  type        = string
  default     = "cdn"
  description = "Concatenated with hosted_zone_name to build the DNS name."
}