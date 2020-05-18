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

################
# AWS SSM Parameters Output
################
resource "aws_ssm_parameter" "bucket_name" {
  name  = "/${var.name}/s3/bucket_name"
  type  = "String"
  value = module.s3_website.bucket_name
}

resource "aws_ssm_parameter" "public_s3_website" {
  name  = "/${var.name}/s3/website_endpoint"
  type  = "String"
  value = module.s3_website.website_endpoint
}

module "cloudfront" {
  source      = "../modules/cloudfront"
  s3_website_domain_name = "frontend.serverless.my.id.s3-website-ap-southeast-1.amazonaws.com"
  alb_domain_name = "istox-aws-alb-1051431446.ap-southeast-1.elb.amazonaws.com"
  cloudfront_path_pattern = "/istox-testing/*"
}
