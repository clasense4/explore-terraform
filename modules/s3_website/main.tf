################
# S3 Website
################
resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${var.bucket_name}/*"
        }
    ]
}
  EOF

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_s3_bucket_object" "indexhtml" {
  bucket = var.bucket_name
  key    = "index.html"
  source = "s3_object/index.html"
}

################
# AWS SSM Parameters Output
################
resource "aws_ssm_parameter" "public_s3_website" {
  name  = "/${var.name}/s3/website_endpoint"
  type  = "String"
  value = aws_s3_bucket.this.website_endpoint
}

resource "aws_ssm_parameter" "bucket_name" {
  name  = "/${var.name}/s3/bucket_name"
  type  = "String"
  value = aws_s3_bucket.this.bucket
}