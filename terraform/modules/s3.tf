# S3 for static content
resource "aws_s3_bucket" "s3_bucket" {
  bucket_prefix = "${var.environment}-${var.app_name}-s3-bucket-"
  force_destroy = true
}

# S3 block rules
resource "aws_s3_bucket_public_access_block" "s3_bucket_block" {
  bucket                  = aws_s3_bucket.s3_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 bucket policy for CloudFront access
data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.s3_bucket.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.distribution.arn]
    }
  }
}

# Connect policy
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket     = aws_s3_bucket.s3_bucket.id
  policy     = data.aws_iam_policy_document.s3_bucket_policy.json
  depends_on = [aws_cloudfront_distribution.distribution]
}

# Static files sync for demo using template module
module "static_files" {
  source = "hashicorp/dir/template"

  version = "1.0.2"

  base_dir = "${path.module}/static"
}

resource "aws_s3_object" "static_files" {
  for_each = module.static_files.files

  bucket       = aws_s3_bucket.s3_bucket.bucket
  key          = each.key
  content_type = each.value.content_type

  source  = each.value.source_path
  content = each.value.content

  source_hash = each.value.digests.base64sha256
}

# S3 Log Bucket
# Add some sort of life cycle policy? -> Delete or move to cheaper storage class ?
resource "aws_s3_bucket" "s3_bucket_logs" {
  bucket_prefix = "${var.environment}-cloudfront-logs-${var.app_name}-"
  force_destroy = true
}