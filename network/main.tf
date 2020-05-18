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
}
