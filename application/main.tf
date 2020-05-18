terraform {
  backend "local" {
    path          = "terraform.tfstate"
    workspace_dir = "workspace"
  }
}

provider "aws" {
  region = "ap-southeast-1"
}


data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.name}/vpc/id"
}
data "aws_ssm_parameter" "public_subnet_0" {
  name = "/${var.name}/public_subnet/0"
}
data "aws_ssm_parameter" "public_subnet_1" {
  name = "/${var.name}/public_subnet/1"
}
data "aws_ssm_parameter" "public_subnet_2" {
  name = "/${var.name}/public_subnet/2"
}

module "alb" {
  source = "../modules/alb"
  name   = var.name
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  public_subnets_id = [
    data.aws_ssm_parameter.public_subnet_0.value,
    data.aws_ssm_parameter.public_subnet_1.value,
    data.aws_ssm_parameter.public_subnet_2.value
  ]
}

module "s3_website" {
  source      = "../modules/s3_website"
  name        = var.name
  bucket_name = var.bucket_name
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = "frontend.serverless.my.id.s3-website-ap-southeast-1.amazonaws.com"
    origin_id   = "S3-Website-frontend.serverless.my.id.s3-website-ap-southeast-1.amazonaws.com"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.1"]
    }
  }

  origin {
    domain_name = "istox-aws-alb-1051431446.ap-southeast-1.elb.amazonaws.com"
    origin_id   = "ALB-istox-aws-alb-1051431446.ap-southeast-1.elb.amazonaws.com"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.1"]
    }
  }

  enabled = true

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-Website-frontend.serverless.my.id.s3-website-ap-southeast-1.amazonaws.com"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    compress               = true
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/istox-testing/*"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "ALB-istox-aws-alb-1051431446.ap-southeast-1.elb.amazonaws.com"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    compress               = true
  }

  price_class = "PriceClass_200"
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
