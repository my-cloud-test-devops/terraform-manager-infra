# Create VPC
resource "aws_vpc" "demo_vpc" {
  cidr_block           = "10.0.0.0/20"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "demo-vpc"
  }
}

# Create public subnets
resource "aws_subnet" "demo_subnet_public_1" {
  vpc_id                  = aws_vpc.demo_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "demo-subnet-public-1"
  }
}

resource "aws_subnet" "demo_subnet_public_2" {
  vpc_id                  = aws_vpc.demo_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "demo-subnet-public-2"
  }
}

# Create private subnets
resource "aws_subnet" "demo_subnet_private_1" {
  vpc_id            = aws_vpc.demo_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "demo-subnet-private-1"
  }
}

resource "aws_subnet" "demo_subnet_private_2" {
  vpc_id            = aws_vpc.demo_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "demo-subnet-private-2"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "demo_igw" {
  vpc_id = aws_vpc.demo_vpc.id

  tags = {
    Name = "demo-igw"
  }
}

# Create Route Table
resource "aws_route_table" "demo_route_table" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_igw.id
  }

  tags = {
    Name = "demo-route-table"
  }
}

# Associate public subnets with the route table
resource "aws_route_table_association" "demo_association_public_1" {
  subnet_id      = aws_subnet.demo_subnet_public_1.id
  route_table_id = aws_route_table.demo_route_table.id
}

resource "aws_route_table_association" "demo_association_public_2" {
  subnet_id      = aws_subnet.demo_subnet_public_2.id
  route_table_id = aws_route_table.demo_route_table.id
}
#---------------------------
# Create Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  instance = null # Specify null to create a standalone EIP, not attached to an EC2 instance
}

# Create NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.demo_subnet_public_1.id # Choose one of the public subnets for the NAT gateway
  depends_on    = [aws_internet_gateway.demo_igw] # Make sure the Internet Gateway is created before the NAT Gateway

  tags = {
    Name = "demo-nat-gateway"
  }
}

# Create Route Table for private subnets
resource "aws_route_table" "demo_private_route_table" {
  vpc_id = aws_vpc.demo_vpc.id

  tags = {
    Name = "demo-private-route-table"
  }
}

# Add a route for the NAT Gateway to the private route table
resource "aws_route" "demo_private_route" {
  route_table_id         = aws_route_table.demo_private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}

# Associate private subnets with the private route table
resource "aws_route_table_association" "demo_association_private_1" {
  subnet_id      = aws_subnet.demo_subnet_private_1.id
  route_table_id = aws_route_table.demo_private_route_table.id
}