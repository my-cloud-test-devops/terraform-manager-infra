




# Create Bastion Host
resource "aws_instance" "demo_bastion_instance" {
  ami           = "ami-079db87dc4c10ac91"
  instance_type = "t2.micro"
  key_name      = "latest_belgium_task"
  subnet_id     = aws_subnet.demo_subnet_public_1.id

  vpc_security_group_ids = [aws_security_group.demo_bastion_sg.id]

  tags = {
    Name = "demo-bastion-instance"
  }

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install docker -y
    systemctl start docker
    usermod -aG docker ec2-user
    docker pull phpmyadmin
    docker run --name myadmin -d -e PMA_HOST=${aws_db_instance.demo_rds_instance.endpoint} -p 80:80 phpmyadmin
  EOF
}

# Create Launch Template
resource "aws_launch_template" "demo_launch_template" {
  name        = "demo-launch-template"
  description = "Demo Launch Template for Webserver"

  image_id      = "ami-079db87dc4c10ac91"
  instance_type = "t2.micro"
  key_name      = "latest_devops_task_new_key_pair"

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 8
      volume_type = "gp3"
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.demo_ec2_instance_profile.name
  }


  network_interfaces {
    security_groups = [aws_security_group.demo_instance_sg.id]
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash

              sudo yum install nginx -y

              echo "server {
                  listen 80;
                  server_name localhost;

                  location / {
                      root /var/www/todoapp/build;
                      index index.html;
                      try_files \$uri \$uri/ /index.html;
                  }

                  error_page 500 502 503 504 /50x.html;
                  location = /50x.html {
                      root /usr/share/nginx/html;
                  }
              }" | sudo tee /etc/nginx/conf.d/todoapp.conf

              aws s3 cp s3://${aws_s3_bucket.demo_s3_bucket.bucket}/client/ /var/www/todoapp/ --recursive
              sudo systemctl start nginx
              sudo systemctl enable nginx
              sudo yum install nodejs -y
              sudo npm install -g pm2
              aws s3 cp s3://${aws_s3_bucket.demo_s3_bucket.bucket}/server/ /todoapp/ --recursive
              npm install -C /todoapp
              pm2 start /todoapp/ecosystem.config.js
              EOF
              )

}

# Create Auto Scaling Group using Launch Template
resource "aws_autoscaling_group" "demo_autoscaling_group" {
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1
  vpc_zone_identifier = [aws_subnet.demo_subnet_private_1.id, aws_subnet.demo_subnet_private_2.id]
  launch_template {
    id      = aws_launch_template.demo_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "webserver-instance"
    propagate_at_launch = true
  }

  health_check_type         = "ELB"
  health_check_grace_period = 300
  force_delete              = true

  lifecycle {
    create_before_destroy = true
  }

  target_group_arns = [
    aws_lb_target_group.demo_tg_80.arn,
    aws_lb_target_group.demo_tg_8080.arn
  ]
}