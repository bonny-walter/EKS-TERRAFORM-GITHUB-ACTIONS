provider "aws" {
  region = "us-east-2"
}

resource "aws_dynamodb_table" "terraform_state_lock" {

 name           = "terraform-state-lock"

 billing_mode   = "PAY_PER_REQUEST"

 hash_key       = "LockID"



 attribute {

   name = "LockID"

   type = "S"

 }

}


# Create an S3 bucket
resource "aws_s3_bucket" "example_bucket" {
  bucket        = "bonny-aws-bucket"
  
  force_destroy = true       # Optional: Allow bucket deletion even if it has objects

  tags = {
    Name        = "example-bucket"
    Environment = "Dev"
  }
}
