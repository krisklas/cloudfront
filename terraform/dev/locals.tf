locals {
  app_name = "cf-distribution"
  environment = "dev"
  dns_name = "${var.domain_name_prefix}.${var.hosted_zone_name}"
}