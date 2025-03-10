# modules/vpc/outputs.tf

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.public[*].id
}

output "private_subnet_id" {
  description = "The ID of the private subnet"
  value       = aws_subnet.private[*].id
}

output "nat_gateway_id" {
  description = "The ID of the NAT gateway"
  value       = aws_nat_gateway.igw_nat[*].id
}

output "internet_gateway_id" {
  description = "The ID of the Internet gateway"
  value       = aws_internet_gateway.igw[*].id
}
