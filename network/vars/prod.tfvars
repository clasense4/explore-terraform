name                 = "istox"
cidr_block           = "10.0.0.0/16"
enable_dns_hostnames = true
azs                  = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
private_subnets      = ["10.0.0.0/19", "10.0.64.0/19", "10.0.128.0/19"]
public_subnets       = ["10.0.32.0/20", "10.0.96.0/20", "10.0.160.0/20"]
vpn_cidr_block       = ["128.199.253.143/32"]
