# Source
resource "aws_cloudwatch_log_delivery_source" "distribution" {

  name         = "${var.environment}-${var.app_name}"
  log_type     = "ACCESS_LOGS"
  resource_arn = aws_cloudfront_distribution.distribution.arn
}

# Desitination
resource "aws_cloudwatch_log_delivery_destination" "distribution_s3" {

  name          = "${var.environment}-${var.app_name}-s3-destination"
  output_format = "json"

  delivery_destination_configuration {
    destination_resource_arn = aws_s3_bucket.s3_bucket_logs.arn
  }
}

# Delivery
resource "aws_cloudwatch_log_delivery" "distribution_s3" {

  delivery_source_name     = aws_cloudwatch_log_delivery_source.distribution.name
  delivery_destination_arn = aws_cloudwatch_log_delivery_destination.distribution_s3.arn

  s3_delivery_configuration {
    suffix_path = "/{accountid}/{DistributionId}/{yyyy}/{MM}/{dd}/{HH}"
  }


  # These are all the available fields for a v2 Logging configuration
  # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/standard-logs-reference.html
  record_fields = [
    "timestamp",
    "date",
    "time",
    "x-edge-location",
    "sc-bytes",
    "c-ip",
    "cs-method",
    "cs(Host)",
    "cs-uri-stem",
    "sc-status",
    "cs(Referer)",
    "cs(User-Agent)",
    "cs-uri-query",
    "cs(Cookie)",
    "x-edge-result-type",
    "x-edge-request-id",
    "x-host-header",
    "cs-protocol",
    "cs-bytes",
    "time-taken",
    "x-forwarded-for",
    "ssl-protocol",
    "ssl-cipher",
    "x-edge-response-result-type",
    "cs-protocol-version",
    "fle-status",
    "fle-encrypted-fields",
    "c-port",
    "time-to-first-byte",
    "x-edge-detailed-result-type",
    "sc-content-type",
    "sc-content-len",
    "sc-range-start",
    "sc-range-end",
    "timestamp(ms)",
    "origin-fbl",
    "origin-lbl",
    "asn",
    "c-country",
    "cache-behavior-path-pattern",
    "distribution-tenant-id"
  ]
}