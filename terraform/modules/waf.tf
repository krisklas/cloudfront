# WAF rate limit
resource "aws_wafv2_web_acl" "rate_limit" {
  name  = "${var.environment}-${var.app_name}-rate-limit"
  scope = "CLOUDFRONT"

  default_action {
    allow {}
  }

  rule {
    name     = "RateLimitRule"
    priority = 1

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 10
        aggregate_key_type = "IP"
        evaluation_window_sec = 60
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimitRule"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.environment}-${var.app_name}-rate-limit"
    sampled_requests_enabled   = true
  }

  tags = {
    Name = "${var.environment}-${var.app_name}-rate-limit"
  }
}