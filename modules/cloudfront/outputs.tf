output "domain_name" {
  description = "Cloudfront distribution domain name"
  value       = aws_cloudfront_distribution.s3_distribution.domain_name
}