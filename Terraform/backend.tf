terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket = "github-actions-demo-2024"
    key    = "github-actions-new.tfstate"
    region = "us-east-1"
  }
}