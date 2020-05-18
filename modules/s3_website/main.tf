################
# S3 Website
################
resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  acl    = "public-read"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${var.bucket_name}/*"
            ]
        }
    ]
}
  EOF

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

################
# AWS SSM Parameters Output
################
resource "aws_ssm_parameter" "public_s3_website" {
  name  = "/${var.name}/public_s3_website"
  type  = "String"
  value = aws_s3_bucket.this.website_domain
}