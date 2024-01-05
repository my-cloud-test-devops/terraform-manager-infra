terraform {
  backend "s3" {
    bucket = "github-actions-demo-2024"
    key    = "github-actions-new.tfstate"
    region = "us-east-1"
  }
}