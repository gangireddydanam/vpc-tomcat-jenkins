# VPC
resource "aws_vpc" "my_vpc" {
  cidr_block       = var.vpc_cidr
  tags = {
    Name = "my_vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my_igw"
  }
}

# Subnets : public
resource "aws_subnet" "my_public" {
  count = length(var.public_cidr)
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = element(var.public_cidr,count.index)
  availability_zone = element(var.azs,count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "my_public-Subnet-${count.index+1}"
  }
}

# Subnets : private
resource "aws_subnet" "my_private" {
  count = length(var.private_cidr)
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = element(var.private_cidr,count.index)
  availability_zone = element(var.azs,count.index)
  map_public_ip_on_launch = false
  tags = {
    Name = "my_private-Subnet-${count.index+1}"
  }
}

# Subnets : data
resource "aws_subnet" "my_data" {
  count = length(var.data_cidr)
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = element(var.data_cidr,count.index)
  availability_zone = element(var.azs,count.index)
  map_public_ip_on_launch = false
  tags = {
    Name = "my_data-Subnet-${count.index+1}"
  }
}

#nat-gw in pub subnet 
#EIP

resource "aws_eip" "my_eip" {
  vpc = true
  tags = {
    Name = "my_eip"
  }
}

resource "aws_nat_gateway" "my_natgw" {
  allocation_id = aws_eip.my_eip.id
  subnet_id     = aws_subnet.my_public[0].id

  tags = {
    Name = "my_natgw"
  }
}

# Route table: attach Internet Gateway 
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
  tags = {
    Name = "publicRouteTable"
  }
}

# Route table: attach Nat-Gateway 
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.my_natgw.id
  }
  tags = {
    Name = "privateRouteTable"
  }
}

# Route table association with public subnets
resource "aws_route_table_association" "public" {
  count = length(var.public_cidr)
  subnet_id      = element(aws_subnet.my_public.*.id,count.index)
  route_table_id = aws_route_table.public_rt.id
}

# Route table association with private subnets
resource "aws_route_table_association" "private" {
  count = length(var.private_cidr)
  subnet_id      = element(aws_subnet.my_private.*.id,count.index)
  route_table_id = aws_route_table.private_rt.id
}

# Route table association with data subnets
resource "aws_route_table_association" "data" {
  count = length(var.data_cidr)
  subnet_id      = element(aws_subnet.my_data.*.id,count.index)
  route_table_id = aws_route_table.private_rt.id
}