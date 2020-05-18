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

module "alb" {
  source = "../modules/alb"
  name   = var.name
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  public_subnets_id = [
    "subnet-0e048ffd0130e4534",
    "subnet-0ddc7cadb0e3ef1e4",
    "subnet-02f60cfc4032a0691"
  ]
}
