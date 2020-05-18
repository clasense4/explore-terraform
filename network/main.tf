terraform {
  backend "local" {
    path          = "terraform.tfstate"
    workspace_dir = "workspace"
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

module "network" {
  source               = "../modules/network"
  name                 = var.name
  cidr_block           = var.cidr_block
  tags                 = var.tags
  azs                  = var.azs
  public_subnets       = var.public_subnets
  private_subnets      = var.private_subnets
  enable_dns_hostnames = var.enable_dns_hostnames
  vpn_cidr_block       = var.vpn_cidr_block
}

################
# AWS SSM Parameters Output
################
resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.name}/vpc/id"
  type  = "String"
  value = module.network.vpc_id
}
resource "aws_ssm_parameter" "public_subnet_0" {
  name  = "/${var.name}/public_subnet/0"
  type  = "String"
  value = module.network.public_subnet_0
}
resource "aws_ssm_parameter" "public_subnet_1" {
  name  = "/${var.name}/public_subnet/1"
  type  = "String"
  value = module.network.public_subnet_1
}
resource "aws_ssm_parameter" "public_subnet_2" {
  name  = "/${var.name}/public_subnet/2"
  type  = "String"
  value = module.network.public_subnet_2
}