module "egress_vpc" {
  source = "../../modules/sg-group"

  #vpc_id                     = "vpc-awsvpccxnprdeus2-aaa1"
  security_group_name        = "awsgsxnprdeus2-aaa1"                            # Custom name
  security_group_description = "NAT gateway security group" # Custom description

  inbound_rules = [
    {
      cidr_blocks = ["10.54.1.0/27"]
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
    },
    {
      cidr_blocks = ["10.54.1.0/27"]
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
    }
  ]

  outbound_rules = [
    {
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = 0
      to_port     = 0
      protocol    = "-1" # All traffic
    }
  ]
}

output "security_group_id" {
  value = module.egress_vpc.security_group_id
}
