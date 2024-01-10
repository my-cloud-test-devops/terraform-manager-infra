# variables.tf

# variable "aws_access_key" {
#   description = "AWS Access Key ID"
# }

# variable "aws_secret_key" {
#   description = "AWS Secret Access Key"
# }

variable "db_username" {
  description = "RDS username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "RDS password"
  type        = string
  sensitive   = true
}

variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
}