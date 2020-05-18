################
# Public subnet
################
resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags = {
    Name = "${var.name}_vpc"
  }
}

################
# Public subnet
################
resource "aws_subnet" "public" {
  count = length(var.public_subnets) > 0 && (length(var.public_subnets) >= length(var.azs)) ? length(var.public_subnets) : 0

  vpc_id                  = aws_vpc.this.id
  cidr_block              = element(concat(var.public_subnets, [""]), count.index)
  availability_zone       = element(concat(var.azs, [""]), count.index)
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags = {
    Name = "${var.name}_public_${count.index}"
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

################
# Internet Gateway
################
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}_igw"
  }
}

################
# Publiс routes
################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}_igw"
  }
}

resource "aws_route" "public_igw_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id

  timeouts {
    create = "5m"
  }
}

################
# Default Public Subnet Security Group
################
resource "aws_security_group" "default_public" {
  name        = "${var.name}_default_public_sg"
  description = "${var.name} default public SG"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.vpn_cidr_block
    description = "VPN IP"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}_public_sg"
  }
}

################
# Private subnet
################
resource "aws_subnet" "private" {
  count = length(var.private_subnets) > 0 && (length(var.private_subnets) >= length(var.azs)) ? length(var.private_subnets) : 0

  vpc_id            = aws_vpc.this.id
  cidr_block        = element(concat(var.private_subnets, [""]), count.index)
  availability_zone = element(concat(var.azs, [""]), count.index)

  tags = {
    Name = "${var.name}_private_${count.index}"
  }
}

################
# Default Private Subnet Security Group
################
resource "aws_security_group" "default_private" {
  name        = "${var.name}_default_private_sg"
  description = "${var.name} default private SG"
  vpc_id      = aws_vpc.this.id
}

resource "aws_security_group_rule" "ssh-sg" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.public_subnets
  security_group_id = aws_security_group.default_private.id
}
