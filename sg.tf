#Load Balancer
resource "aws_security_group" "demo_lb_sg" {
  vpc_id      = var.vpc_id
  name        = var.security_group_name
  description = var.security_group_description

  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.cidr_blocks
  }
}

resource "aws_security_group" "demo_instance_sg" {
  vpc_id      = aws_vpc.demo_vpc.id
  name        = "demo-instance-sg"
  description = "Receives traffic only from Load Balancer"

  dynamic "ingress" {
    for_each = var.ec2_ingress_ports

    content {
      from_port       = ingress.value
      to_port         = ingress.value
      protocol        = "tcp"
      security_groups = [aws_security_group.demo_lb_sg.id]
    }
  }

  dynamic "ingress" {
    for_each = [22]

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "egress" {
    for_each = var.ec2_ingress_ports

    content {
      from_port       = egress.value
      to_port         = egress.value
      protocol        = "-1"
      cidr_blocks     = ["0.0.0.0/0"]
    }
  }
}