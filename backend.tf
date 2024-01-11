terraform {
  backend "s3" {
    bucket         = "github-new-bucket-test-2024"
    key            = "github-actions.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
}
}