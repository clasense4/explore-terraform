variable "name" {
  description = "Name identifier"
  type        = string
  default     = ""
}

variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "0.0.0.0/0"
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames for the VPC"
  type        = bool
  default     = false
}

variable "enable_dns_support" {
  description = "Enable DNS support for the VPC"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags for this module"
  type        = map(string)
  default     = {}
}

variable "azs" {
  description = "List of availability zones names in the region"
  type        = list(string)
  default     = []
}

variable "public_subnets" {
  description = "List of public subnets for the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "List of private subnets for the VPC"
  type        = list(string)
  default     = []
}

variable "map_public_ip_on_launch" {
  description = "Auto assign public IP"
  type        = bool
  default     = true
}
