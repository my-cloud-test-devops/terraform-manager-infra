  terraform {
  backend "s3" {
    bucket = "github-new-bucket-test-2024"
    key    = "github-actions-new.tfstate"
    region = "us-east-1"
  }
  }