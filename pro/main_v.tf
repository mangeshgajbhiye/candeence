# main.tf

# provider "aws" {
#   region = "us-east-1"  # Specify the region you want
# }

module "vpc_1" {
  source              = "../modules/vpc_module"
  vpc_name            = "vpc-1"
  vpc_cidr            = "10.0.0.0/16"
  availability_zone   = "us-east-1a"
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
}

module "vpc_2" {
  source              = "../modules/vpc_module"
  vpc_name            = "vpc-2"
  vpc_cidr            = "10.1.0.0/16"
  availability_zone   = "us-east-1b"
  public_subnet_cidr  = "10.1.1.0/24"
  private_subnet_cidr = "10.1.2.0/24"
}
