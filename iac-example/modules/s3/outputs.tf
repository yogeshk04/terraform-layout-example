# export the s3 bucket name
output "bucket_name" {
  value = aws_s3_bucket.s3_bucket.id
}

output "website_url" {
    description = "URL of the website"
    value = aws_s3_bucket_website_configuration.s3_bucket_website_configuration.website_endpoint  
}