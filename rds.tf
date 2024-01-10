# Create the RDS MySQL Database in the Private Subnet
resource "aws_db_instance" "demo_rds_instance" {
  identifier             = "demo-rds-instance"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0.35"
  instance_class         = "db.t2.micro"
#   username               = var.db_username
#   password               = var.db_password
  port                   = 3306
  publicly_accessible    = false
  multi_az               = false
  storage_type           = "gp2"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.demo_rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.demo_db_subnet_group.name

  tags = {
    Name = "demo-rds-instance"
  }
}

# Create a DB Subnet Group for the RDS instance
resource "aws_db_subnet_group" "demo_db_subnet_group" {
  name       = "demo-db-subnet-group"
  subnet_ids = [aws_subnet.demo_subnet_private_1.id, aws_subnet.demo_subnet_private_2.id]
}

# Create IAM Role
resource "aws_iam_role" "demo_ec2_role" {
  name = "demo-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}