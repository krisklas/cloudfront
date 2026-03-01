# Generate private key for CloudFront signing
resource "tls_private_key" "cloudfront_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Save private key to local file for demo
resource "local_file" "private_key" {
  content         = tls_private_key.cloudfront_key.private_key_pem
  filename        = "${path.module}/keys/${var.environment}_private_key.pem"
  file_permission = "0600"
}

# Save public key to local file for demo
resource "local_file" "public_key" {
  content         = tls_private_key.cloudfront_key.public_key_pem
  filename        = "${path.module}/keys/${var.environment}_public_key.pem"
  file_permission = "0644"
}

# CloudFront Public Key resource
resource "aws_cloudfront_public_key" "auth_key" {
  comment     = "${var.environment}-${var.app_name} signing key"
  encoded_key = tls_private_key.cloudfront_key.public_key_pem
  name        = "${var.environment}-${var.app_name}-key"
}

# CloudFront Key Group
resource "aws_cloudfront_key_group" "auth_key_group" {
  comment = "${var.environment}-${var.app_name} key group for signed cookies"
  items   = [aws_cloudfront_public_key.auth_key.id]
  name    = "${var.environment}-${var.app_name}-key-group"
}