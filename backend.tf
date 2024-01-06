 # CREATE S3 BUCKET
 
 resource "aws_s3_bucket" "my_bucket" {
  bucket = "github-new-bucket-test-2024"
  versioning {
   enabled = true
  }
  server_side_encryption_configuration{
   rule {
     apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
  }
 }

 #Crearte DynamoDB
 resource "aws_dynamodb_table" "statelock" {
  name = "state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
   
  attribute {
     name = "LockID"
     type = "S"
   }
 }