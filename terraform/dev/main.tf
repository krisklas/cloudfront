terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      "app"         = local.app_name
      "environment" = local.environment
    }
  }
}

module "cdn" {
  source = "../modules"

  environment = local.environment
  app_name    = local.app_name
  dns_name    = local.dns_name

  certificate_arn = aws_acm_certificate_validation.cert.certificate_arn
}