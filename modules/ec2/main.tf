resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = var.associate_public_ip_address
  security_groups             = var.security_groups
  subnet_id                   = var.subnet_id

  tags = {
    Name        = var.name
    Description = "Managed by terraform"
    Environment = "test"
  }
  lifecycle {
    ignore_changes = [
      # Ignore changes to security group, it will force a new resource
      tags, security_groups, vpc_security_group_ids, associate_public_ip_address
    ]
  }
}