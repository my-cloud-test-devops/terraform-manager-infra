# Create Launch Template
resource "aws_launch_template" "demo_launch_template" {
  name          = "demo-launch-template"
  description   = "Demo Launch Template for Webserver"
  
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

  network_interfaces {
    security_groups = [aws_security_group.demo_instance_sg.id]
  }

  user_data = base64encode(
    <<-USERDATA
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
    USERDATA
  )

}

# Create Auto Scaling Group using Launch Template
# resource "aws_autoscaling_group" "demo_autoscaling_group" {
#   #count = length(var.pub_subnet_ids)
#   desired_capacity     = 1
#   max_size             = 1
#   min_size             = 1
#   #vpc_zone_identifier  =  aws_subnet.demo_subnet_public[count.index]
#   #vpc_zone_identifier  = element(var.pub_subnet_ids, count.index)
#   vpc_zone_identifier  = [aws_subnet.pub_subnet_id_1.id, aws_subnet.pub_subnet_id_2.id]
#   launch_template {
#     id      = aws_launch_template.demo_launch_template.id
#     version = "$Latest"
#   }

#   tag {
#     key                 = "Name"
#     value               = "webserver-instance"
#     propagate_at_launch = true
#   }

#   health_check_type          = "ELB"
#   health_check_grace_period  = 300
#   force_delete               = true

#   lifecycle {
#     create_before_destroy = true
#   }

#   target_group_arns = [
#     aws_lb_target_group.demo_tg_80.arn,
#     aws_lb_target_group.demo_tg_8080.arn
#   ]
# }

#AUTO_SCALING_GROUP

# resource "aws_autoscaling_group" "demo_autoscaling_group" {
#   desired_capacity     = 1
#   max_size             = 1
#   min_size             = 1
#   vpc_zone_identifier  = var.pub_subnet_ids
#    #vpc_zone_identifier  = [data.aws_subnet.pub-subnet-metadata[0]["subnet_id"]]
#   launch_template {
#     id      = aws_launch_template.demo_launch_template.id
#     version = "$Latest"  # Update with the actual version
#   }

#   tag {
#     key                 = "Name"
#     value               = "webserver-instance"
#     propagate_at_launch = true
#   }

#   health_check_type          = "EC2"
#   health_check_grace_period  = 300
#   force_delete               = true

#   lifecycle {
#     create_before_destroy = true
#   }

  # Add other configurations as needed
#}

#Target Group:

# resource "aws_lb_target_group" "demo_tg_80" {
#   name        = "demo-tg-80"
#   port        = 80
#   protocol    = "HTTP"
#   target_type = "instance"
#   vpc_id      = aws_vpc.demo_vpc.id
# }

# resource "aws_lb_target_group" "demo_tg_8080" {
#   name        = "demo-tg-8080"
#   port        = 8080
#   protocol    = "HTTP"
#   target_type = "instance"
#   vpc_id      = aws_vpc.demo_vpc.id
# }

# resource "aws_lb_listener" "demo_listener_80" {
#   load_balancer_arn = aws_lb.demo_alb.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     target_group_arn = aws_lb_target_group.demo_tg_80.arn
#     type             = "forward"
#   }
# }