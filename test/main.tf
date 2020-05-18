variable "name" {
  description = "Name identifier"
  type        = string
  default     = ""
}

################
# Private Instance
################
data "aws_ssm_parameter" "private_sg" {
  name = "/${var.name}/vpc/subnet/private/sg"
}
data "aws_ssm_parameter" "private_subnet" {
  name = "/${var.name}/private_subnet/0"
}
module "ec2_private" {
  source                      = "../modules/ec2"
  name                        = "private-subnet-1a"
  ami_id                      = "ami-07ce5f60a39f1790e"
  instance_type               = "t2.micro"
  key_name                    = "training_fajri"
  associate_public_ip_address = false
  security_groups             = [data.aws_ssm_parameter.private_sg.value]
  subnet_id                   = data.aws_ssm_parameter.private_subnet.value
  user_data                   = "userdata_dummy.sh"
}
output "instance_private_ip" {
  value = module.ec2_private.private_ip
}


################
# Public Instance 1
################
data "aws_ssm_parameter" "public_sg" {
  name = "/${var.name}/vpc/subnet/public/sg"
}
data "aws_ssm_parameter" "public_subnet" {
  name = "/${var.name}/public_subnet/1"
}
data "aws_ssm_parameter" "target_group_arn" {
  name = "/${var.name}/alb/target_group/arn"
}
module "ec2_public" {
  source                      = "../modules/ec2"
  name                        = "public-subnet-1b"
  ami_id                      = "ami-07ce5f60a39f1790e"
  instance_type               = "t2.micro"
  key_name                    = "training_fajri"
  associate_public_ip_address = true
  security_groups             = [data.aws_ssm_parameter.public_sg.value]
  subnet_id                   = data.aws_ssm_parameter.public_subnet.value
  user_data                   = "userdata_php.sh"
}
resource "aws_lb_target_group_attachment" "instance_public1" {
  target_group_arn = data.aws_ssm_parameter.target_group_arn.value
  target_id        = module.ec2_public.id
  port             = 80
}
output "instance_public1_dns" {
  value = module.ec2_public.public_dns
}


################
# Public Instance 2
################
data "aws_ssm_parameter" "public_subnet2" {
  name = "/${var.name}/public_subnet/2"
}
module "ec2_public_2" {
  source                      = "../modules/ec2"
  name                        = "public-subnet-1c"
  ami_id                      = "ami-07ce5f60a39f1790e"
  instance_type               = "t2.micro"
  key_name                    = "training_fajri"
  associate_public_ip_address = true
  security_groups             = [data.aws_ssm_parameter.public_sg.value]
  subnet_id                   = data.aws_ssm_parameter.public_subnet2.value
  user_data                   = "userdata_php.sh"
}
resource "aws_lb_target_group_attachment" "instance_public2" {
  target_group_arn = data.aws_ssm_parameter.target_group_arn.value
  target_id        = module.ec2_public_2.id
  port             = 80
}
output "instance_public2_dns" {
  value = module.ec2_public_2.public_dns
}