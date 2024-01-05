terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket = "github-new-bucket-test-2024"
    key    = "github-actions-new.tfstate"
    region = "us-east-1"
  }
}