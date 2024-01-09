# VPC CIDR
variable "vpc_id" {
    type = string
    default = "192.168.10.0/24"
}

# VPC NAME
variable "vpc_name" {
    type = object({
      Name = string
    })
default = {
      Name = "my_vpc"
    }
}

# Public PUB_CIDR
variable "pub_cidr_1" {
    type = string
    default = "192.168.10.0/26"
}

variable "pub_cidr_2" {
  type = string
  default = "192.168.10.64/26"
  
}

# # Public Subnet Ids
# variable "pub_subnet_ids" {
#   type    = list(string)
#   default = ["pub_subnet_id_1", "pub_subnet_id_2"]
# }

# Publice Subnet Tags
variable "subnet_tag_pub_1" {
    type    = string
  default = "pub_subnet_id_1"
}

variable "subnet_tag_pub_2" {
    type    = string
  default = "pub_subnet_id_2"
}

# Private PRI_CIDR
variable "pri_cidr" {
    type = list(string)
    default = ["192.168.10.128/26", "192.168.10.192/26"]
}

#Private Subnet Tags
variable "subnet_tag_pri" {
    type = list(object({
      Name = string
    }))
    default =  [{
      Name = "pri-subnet-1"
    },
    {
      Name = "pri-subnet-2"
    } ]
}

#Private Subnet Ids
variable "pri_subnet_ids" {
  type    = list(string)
  default = ["pri_subnet_id_1", "pri_subnet_id_2"]
}

##Internet Gateway##
variable "intennet_gateway" {
  type = object({
    Name = string
  })
  
  default = {
    Name = "demo-igw"
  }
}
# Internet_Gateway_Routable

variable "route_table"{
  type = object({
    Name = string 
  })  
    default = {
    Name = "demo-route-table"
  }
}

# Security Group
variable "security_group_name" {
  default     = "demo-lb-sg"
}

variable "security_group_description" {
  default     = "Load Balancer Security Group"
}

variable "ingress_ports" {
  type        = list(number)
  default     = [80, 8080,]
}

variable "cidr_blocks" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ec2_ingress_ports" {
  type        = list(number)
  default     = [80, 8080,22]
}

# #ZONE
# variable "vpc_zone_identifier" {
#     type = list(string)
#     default = ["pub_subnet_id_1", "pub_subnet_id_2"]
  
# }

#Availability_Zones:

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]  # Update with your desired availability zones
}

#
# variable "demo_alb_subnets" {
#     type = list(string)
#     default = ["pub_subnet_id_1", "pub_subnet_id_2"]
  
# }

#ALB_NAME
variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
  default     = "demo-alb"
}

#LAUNCH_TEMPLATE
