# Create VPC
resource "aws_vpc" "demo_vpc" {
  cidr_block = var.vpc_id
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = var.vpc_name
}

# Create public subnets
resource "aws_subnet" "demo_subnet_public" {
    count = length(var.pub_cidr)
    vpc_id = aws_vpc.demo_vpc.id
    cidr_block = element(var.pub_cidr, count.index)
    map_public_ip_on_launch = true
    enable_resource_name_dns_a_record_on_launch = true
    tags = element(var.subnet_tag_pub, count.index)
}

# Create private subnets
resource "aws_subnet" "demo_subnet_private" {
    count = length(var.pri_cidr)
    vpc_id = aws_vpc.demo_vpc.id
    cidr_block = element(var.pri_cidr, count.index)
    map_public_ip_on_launch = true
    enable_resource_name_dns_a_record_on_launch = true
    tags = element(var.subnet_tag_pri, count.index)
}

# Create Internet Gateway
resource "aws_internet_gateway" "demo_igw" {
  vpc_id = aws_vpc.demo_vpc.id
  tags = var.intennet_gateway
}

# Create Route Table
resource "aws_route_table" "demo_route_table" {
  vpc_id = aws_vpc.demo_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_igw.id
  }
  tags = var.route_table
}

# Associate public subnets with the route table
# resource "aws_route_table_association" "demo_association_public" {
#   count = length(var.pub_subnet_ids)
#   subnet_id  = element (var.pub_subnet_ids, count.index)
#   route_table_id = aws_route_table.demo_route_table.id
# }

data "aws_subnet" "pub-subnet-metadata" {
  count = length(var.subnet_tag_pub)
  depends_on = [aws_subnet.demo_subnet_public]
  filter {
    name   = "tag:Name"
    values = [element(var.subnet_tag_pub[*].Name, count.index)]
  }
}

resource "aws_route_table_association" "demo_association_public" {
  count = length(var.pub_cidr)
  route_table_id = aws_route_table.demo_route_table.id
  subnet_id = data.aws_subnet.pub-subnet-metadata[count.index].id
}

# Associate private subnets with the route table
# resource "aws_route_table_association" "demo_association_private" {
#   count = length(var.pri_subnet_ids)
#   subnet_id  = element (var.pri_subnet_ids, count.index)
#   route_table_id = aws_route_table.demo_route_table.id
# }

# data "aws_subnet" "pri-subnet-metadata" {
#   count = length(var.subnet_tag_pub)
#   depends_on = [aws_subnet.demo_subnet_private]
#   filter {
#     name   = "tag:Name"
#     values = [element(var.subnet_tag_pri[*].Name, count.index)]
#   }
# }

# resource "aws_route_table_association" "pri-ass" {
#   count = length(var.pub_cidr)
#   route_table_id = aws_route_table.main-pri-rt.id
#   subnet_id = data.aws_subnet.pri-subnet-metadata[count.index].id
# }

#Application Load Balance:
resource "aws_lb" "demo_alb" {
  #count = length(var.pub_subnet_ids)
  name               = "demo_alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.demo_lb_sg.id]
  #subnets            = [aws_subnet.demo_subnet_public_1.id, aws_subnet.demo_subnet_public_2.id]
  subnets            = var.pub_subnet_ids
  enable_deletion_protection = false

  enable_http2        = true
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "demo_alb"
  }
}
