# CloudFront Origin Access Control for S3
resource "aws_cloudfront_origin_access_control" "s3_oac" {
  name                              = "${var.environment}-${var.app_name}-s3-oac"
  description                       = "OAC for S3 bucket access"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Cache Policy
resource "aws_cloudfront_cache_policy" "cache_policy" {
  name        = "${var.environment}-${var.app_name}-cache-policy"
  comment     = "Cache policy for protected content"
  default_ttl = 300   # 5 minutes
  max_ttl     = 86400 # 24 hours
  min_ttl     = 0

  parameters_in_cache_key_and_forwarded_to_origin {
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true

    # No query parameters in cache key
    query_strings_config {
      query_string_behavior = "none"
    }
    # No special headers in cache key
    headers_config {
      header_behavior = "none"
    }
    # No cookies in cache key
    cookies_config {
      cookie_behavior = "none"
    }
  }
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "distribution" {

  # Listen to our DNS name
  aliases = [var.dns_name]

  enabled             = true
  http_version        = "http3"
  is_ipv6_enabled     = true
  price_class         = "PriceClass_100"

  # Origin: S3 Bucket
  origin {
    domain_name              = aws_s3_bucket.s3_bucket.bucket_regional_domain_name
    origin_id                = "s3-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_oac.id

  }

  # Default behavior
  default_cache_behavior {
    target_origin_id       = "s3-origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    cache_policy_id        = aws_cloudfront_cache_policy.cache_policy.id
    trusted_key_groups     = [aws_cloudfront_key_group.auth_key_group.id]
  }

  # Restrictions
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Viewer certificate
  viewer_certificate {
    cloudfront_default_certificate = false

    acm_certificate_arn      = aws_acm_certificate_validation.cert.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"

  }

  tags = {
    Name        = "${var.environment}-${var.app_name}"
    Environment = var.environment
  }

  # WAF
  web_acl_id = aws_wafv2_web_acl.rate_limit.arn

  # Logging config for V1
  logging_config {
    bucket          = aws_s3_bucket.s3_bucket_logs.bucket_domain_name
    prefix          = "${var.environment}/v1/"
    include_cookies = false
  }
}

# Metrics
resource "aws_cloudfront_monitoring_subscription" "metrics" {
  distribution_id = aws_cloudfront_distribution.distribution.id

  monitoring_subscription {
    realtime_metrics_subscription_config {
      realtime_metrics_subscription_status = "Enabled" #Additional metrics: 2.40$/month
    }
  }
}