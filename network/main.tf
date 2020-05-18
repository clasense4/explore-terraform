terraform {
  backend "local" {
    path = "terraform.tfstate"
    workspace_dir = "workspace"
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

module "vpc" {
  source = "../modules/network"
  name = var.name
  cidr_block = var.cidr_block
  vpc_tags = {
    Name = var.name
  }
}
