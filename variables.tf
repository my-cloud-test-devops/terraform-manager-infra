# variables.tf

variable "aws_access_key" {
  description = "AWS Access Key ID"
}

variable "aws_secret_key" {
  description = "AWS Secret Access Key"
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
}