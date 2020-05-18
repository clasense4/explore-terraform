variable "s3_website_domain_name" {
  description = "S3 Website domain name"
  type        = string
}

variable "alb_domain_name" {
  description = "ALB domain name"
  type        = string
}

variable "cloudfront_path_pattern" {
  description = "Cloudfront path pattern for forwarding to ALB"
  type        = string
}