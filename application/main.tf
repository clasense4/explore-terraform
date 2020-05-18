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
