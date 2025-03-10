resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

# Create Public Subnets if `create_public_subnets` is true
resource "aws_subnet" "public" {
  count = var.create_public_subnets ? length(var.public_subnet_cidr_blocks) : 0
  #count = length(var.public_subnet_cidr_blocks)
  vpc_id = aws_vpc.main.id
  cidr_block = element(var.public_subnet_cidr_blocks, count.index)
  availability_zone = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

# Create Private Subnets (Always created regardless of the `create_public_subnets` flag)
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr_blocks)
  vpc_id = aws_vpc.main.id
  cidr_block = element(var.private_subnet_cidr_blocks, count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

# Create Internet Gateway if `create_public_subnets` is true
resource "aws_internet_gateway" "igw" {
  count = var.create_public_subnets ? 1 : 0
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.vpc_name}-InternetGateway"
  }
}

# resource "aws_nat_gateway" "igw_nat" {
#   allocation_id = aws_eip.nat.id
#   subnet_id = aws_subnet.public[0].id
#   depends_on = [aws_internet_gateway.igw]

#    tags = {
#     Name = "${var.vpc_name}-nat-gateway"
#   }
# }

# Create NAT Gateways if `create_public_subnets` is true
resource "aws_nat_gateway" "igw_nat" {
  count = var.create_public_subnets && var.create_nat_gateway ? 2 : 0
  #count          = var.create_nat_gateway ? 2 : 0  # Only create if true
  allocation_id  = aws_eip.nat[count.index].id
  subnet_id      = aws_subnet.public[count.index].id
  depends_on     = [aws_internet_gateway.igw]
  tags = {
     Name = "${var.vpc_name}-nat-gateway"
  }

}

# resource "aws_eip" "nat" {
#   domain = "vpc"
# }

# Create EIPs for NAT Gateways if `create_public_subnets` is true
resource "aws_eip" "nat" {
  count = var.create_public_subnets && var.create_nat_gateway ? 2 : 0
  #count = var.create_nat_gateway ? 2 : 0
  domain = "vpc"
}

# Create Route Table for Public Subnets if `create_public_subnets` is true
resource "aws_route_table" "public" {
  count = var.create_public_subnets ? 1 : 0
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[0].id
  }
  tags = {
    Name = "${var.vpc_name}-public-route-table"
  }
}

# Associate Public Route Table to Public Subnets if `create_public_subnets` is true
resource "aws_route_table_association" "public" {
  count = var.create_public_subnets ? length(aws_subnet.public) : 0
  #count = length(aws_subnet.public)
  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[0].id
}

# resource "aws_route_table" "private" {
#   vpc_id = aws_vpc.main.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.igw_nat.id
#   }
#   tags = {
#     Name = "${var.vpc_name}-private-route-table"
#   }
# }

# Create Route Table for Private Subnets (Always created)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    # Only use NAT Gateway if it's created
    #nat_gateway_id = var.create_nat_gateway ? aws_nat_gateway.igw_nat[count.index].id : null
    nat_gateway_id = var.create_public_subnets && var.create_nat_gateway ? aws_nat_gateway.igw_nat[0].id : null
  }
  tags = {
    Name = "${var.vpc_name}-private-route-table"
  }
}

# Associate Route Table to Private Subnets (Always created)
resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)
  subnet_id = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
