variable "hosted_zone_id" {
  type        = string
  default     = "12345"
  description = "ID of the hosted zone"
}

variable "hosted_zone_name" {
  type        = string
  default     = "dev.domain.com"
  description = "Name of the hosted zone to deploy to."
}

variable "domain_name_prefix" {
  type        = string
  default     = "cdn"
  description = "Concatenated with hosted_zone_name to build the DNS name."
}