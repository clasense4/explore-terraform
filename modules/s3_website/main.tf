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
  depends_on = [
    aws_s3_bucket.this
  ]
}