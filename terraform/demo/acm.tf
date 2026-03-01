resource "aws_acm_certificate" "cert" {
  domain_name       = local.dns_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${local.environment}-${local.app_name}-cert"
  }
}

# Wait for terraform to finish deployment, until certificate is ready
resource "aws_acm_certificate_validation" "cert" {
  certificate_arn = aws_acm_certificate.cert.arn
}