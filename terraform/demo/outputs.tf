output "customer_cert_validation_name" {
  value = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_name
}
output "customer_cert_validation_value" {
  value = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_value
}
output "cloudfront_domain_name" {
  value = module.cdn.cloudfront_domain_name
}