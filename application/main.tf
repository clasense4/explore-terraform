terraform {
  backend "local" {
    path          = "terraform.tfstate"
    workspace_dir = "workspace"
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

module "alb" {
  source = "../modules/alb"
  name   = var.name
  vpc_id = "vpc-08870124919302c57"
  public_subnets_id = [
    "subnet-0e048ffd0130e4534",
    "subnet-0ddc7cadb0e3ef1e4",
    "subnet-02f60cfc4032a0691"
  ]
}
