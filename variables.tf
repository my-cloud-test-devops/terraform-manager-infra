# variables.tf

variable "aws_region" {
  description = "AWS region where VPC will be created"
  default     = "us-east-1"  # Change this to your desired region
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"  # Change this to your desired CIDR block
}

variable "public_subnet_cidr_blocks" {
  description = "CIDR blocks for public subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]  # Change these to your desired public subnet CIDR blocks
}

variable "private_subnet_cidr_blocks" {
  description = "CIDR blocks for private subnets"
  default     = ["10.0.3.0/24", "10.0.4.0/24"]  # Change these to your desired private subnet CIDR blocks
}