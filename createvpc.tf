# Configure the AWS Provider
provider "aws" {
  region = "us-east-1" # Replace with your desired region
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# Create Public Subnets
resource "aws_subnet" "public" {
  count = 2
  vpc_id = aws_vpc.main.id
  cidr_block = ["10.0.1.0/24", "10.0.2.0/24"]
  availability_zone = ["us-east-1a", "us-east-1b"]

  tags = {
    Name = "Public Subnet ${count.index}"
  }
}

# Create Private Subnets
resource "aws_subnet" "private" {
  count = 2
  vpc_id = aws_vpc.main.id
  cidr_block = ["10.0.10.0/24", "10.0.11.0/24"]
  availability_zone = ["us-east-1a", "us-east-1b"]

  tags = {
    Name = "Private Subnet ${count.index}"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

# Create a NAT Gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.private[0].id # Choose a private subnet

  tags = {
    Name = "NAT Gateway"
  }
}

# Create an Elastic IP for the NAT Gateway
resource "aws_eip" "nat" {
}

# Create Route Tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }
}

# Associate Route Tables with Subnets
resource "aws_route_table_association" "public" {
  count = 2
  subnet_id     = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = 2
  subnet_id     = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# Create a Load Balancer (Replace with your desired configuration)
resource "aws_lb" "main" {
  # ... your load balancer configuration
}