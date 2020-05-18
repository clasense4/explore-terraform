output "bucket_name" {
  description = "Bucket Name"
  value       = aws_s3_bucket.this.bucket
}

output "website_endpoint" {
  description = "S3 Website endpoint"
  value       = aws_s3_bucket.this.website_endpoint
}