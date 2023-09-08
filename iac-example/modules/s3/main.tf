# Create S3 bucket
resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name

  tags = {
    Name = "${var.project_name}-${var.environment}-s3-bucket"
  }
}

resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket = aws_s3_bucket.s3_bucket.id
  acl    = "public-read"
  depends_on = [ aws_s3_bucket_ownership_controls.s3_bucket_ownership_controls ]
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_ownership_controls" {
    bucket = aws_s3_bucket.s3_bucket.id
    rule {
      object_ownership = "BucketOwnerPreferred"
    }
    depends_on = [ aws_s3_bucket_public_access_block.s3_bucket_public_access_block ]
  
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

}
resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.s3_bucket.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "PublicReadGetObject",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "s3:GetObject",
        "Resource" : "arn:aws:s3:::${var.bucket_name}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.s3_bucket_public_access_block]
}

resource "aws_s3_bucket_website_configuration" "s3_bucket_website_configuration" {
  bucket = aws_s3_bucket.s3_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

}
