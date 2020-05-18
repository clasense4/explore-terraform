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
  source         = "../modules/network"
  name           = var.name
  cidr_block     = var.cidr_block
  tags           = var.tags
  azs            = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  public_subnets = ["10.0.32.0/20", "10.0.96.0/20", "10.0.160.0/20"]
}
