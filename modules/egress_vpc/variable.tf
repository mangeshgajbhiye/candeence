variable "vpc_name" {}
variable "cidr_block" {}
variable "availability_zones" {}
variable "public_subnet_cidr_blocks" {}
variable "private_subnet_cidr_blocks" {}
variable "create_nat_gateway" {
  type    = bool
  default = true  # Default to true if you want it to be created by default
}
variable "create_public_subnets" {
  type    = bool
  default = false  # Set this to true if you want to create public subnets as well
}
