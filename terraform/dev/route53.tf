resource "aws_route53_record" "cloudfront_alias" {
  zone_id = var.hosted_zone_id
  name    = local.dns_name
  type    = "A"

  alias {
    name                   = module.cdn.cloudfront_domain_name
    zone_id                = module.cdn.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "cloudfront_alias_ipv6" {
  zone_id = var.hosted_zone_id
  name    = local.dns_name
  type    = "AAAA"

  alias {
    name                   = module.cdn.cloudfront_domain_name
    zone_id                = module.cdn.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}