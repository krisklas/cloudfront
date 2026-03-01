# Enable ACL
resource "aws_s3_bucket_ownership_controls" "logs" {
  bucket = aws_s3_bucket.s3_bucket_logs.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

data "aws_canonical_user_id" "current" {}

# Define ACL
resource "aws_s3_bucket_acl" "logs" {
  depends_on = [aws_s3_bucket_ownership_controls.logs]
  bucket     = aws_s3_bucket.s3_bucket_logs.id

  access_control_policy {
    owner {
      id = data.aws_canonical_user_id.current.id
    }
    grant {
      grantee {
        id   = data.aws_canonical_user_id.current.id
        type = "CanonicalUser"
      }
      permission = "FULL_CONTROL"
    }

    grant {
      grantee {
        # This ID is hardcoded by AWS for all CloudFront v1 log deliveries
        id   = "c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0"
        type = "CanonicalUser"
      }
      permission = "FULL_CONTROL"
    }
  }
}