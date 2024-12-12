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
  bucket        = "my-example-bucket-unique-name"
  
  force_destroy = true       # Optional: Allow bucket deletion even if it has objects

  tags = {
    Name        = "example-bucket"
    Environment = "Dev"
  }
}

# Enable versioning
resource "aws_s3_bucket_versioning" "example" {
  bucket = aws_s3_bucket.example_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.example_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Add bucket policy to allow access to specific IAM roles/users
resource "aws_s3_bucket_policy" "example" {
  bucket = aws_s3_bucket.example_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowPublicRead"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.example_bucket.arn}/*"
      }
    ]
  })
}

# Enable access logging (requires a logging bucket)
resource "aws_s3_bucket" "logging_bucket" {
  bucket        = "my-logging-bucket-unique-name"
  
  force_destroy = true

  tags = {
    Name = "logging-bucket"
  }
}

resource "aws_s3_bucket_logging" "example" {
  bucket = aws_s3_bucket.example_bucket.id

  target_bucket = aws_s3_bucket.logging_bucket.id
  target_prefix = "log/"
}

# Outputs
output "bucket_name" {
  value = aws_s3_bucket.example_bucket.id
}
