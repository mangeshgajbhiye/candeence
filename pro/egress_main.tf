/*module "egress_vpc" {
  source = "../modules/egress_vpc" # Adjust the path as per your module location

  vpc_name                   = "egress-vpc"
  cidr_block                 = "10.0.0.0/16"
  availability_zones         = ["ap-south-1a", "ap-south-1b"]
  public_subnet_cidr_blocks  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidr_blocks = ["10.0.3.0/24", "10.0.4.0/24","10.0.5.0/24","10.0.6.0/24"]
}*/

module "egress_vpc" {
  source = "../modules/egress_vpc" # Adjust the path as per your module location

  vpc_name                   = "egress-vpc"
  cidr_block                 = "10.0.0.0/16"
  availability_zones         = ["ap-south-1a", "ap-south-1b"]
  public_subnet_cidr_blocks  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidr_blocks = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  #create_nat_gateway         = false
  create_public_subnets = false
}