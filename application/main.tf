terraform {
  backend "local" {
    path          = "terraform.tfstate"
    workspace_dir = "workspace"
  }
}

provider "aws" {
  region = "ap-southeast-1"
}


################
# ALB Module
################
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
resource "aws_ssm_parameter" "alb_dns" {
  name  = "/${var.name}/alb/dns"
  type  = "String"
  value = module.alb.dns_name
}
resource "aws_ssm_parameter" "alb_target_group_arn" {
  name  = "/${var.name}/alb/target_group/arn"
  type  = "String"
  value = module.alb.target_group_arn
}


################
# S3 Website Module
################
module "s3_website" {
  source      = "../modules/s3_website"
  name        = var.name
  bucket_name = var.bucket_name
}
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


################
# Cloudfront Module
################
data "aws_ssm_parameter" "alb" {
  name = "/${var.name}/alb/dns"
}
data "aws_ssm_parameter" "s3" {
  name = "/${var.name}/s3/website_endpoint"
}
module "cloudfront" {
  source      = "../modules/cloudfront"
  s3_website_domain_name = data.aws_ssm_parameter.s3.value
  alb_domain_name = data.aws_ssm_parameter.alb.value

  cloudfront_path_pattern = "/istox-testing/*"
}
resource "aws_ssm_parameter" "cloudfront_output" {
  name  = "/${var.name}/cloudfront/domain"
  type  = "String"
  value = module.cloudfront.domain_name
}