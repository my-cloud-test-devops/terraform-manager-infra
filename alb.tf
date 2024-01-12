resource "aws_lb" "demo_alb" {
  name                       = "demo-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.demo_lb_sg.id]
  subnets                    = [aws_subnet.demo_subnet_public_1.id, aws_subnet.demo_subnet_public_2.id]
  enable_deletion_protection = false

  enable_http2                     = true
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "demo-alb"
  }
}

resource "aws_lb_target_group" "demo_tg_80" {
  name        = "demo-tg-80"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.demo_vpc.id

  health_check {
    path                = "/"  
    port                = 80        
    protocol            = "HTTP"    
    interval            = 60         
    timeout             = 5          
    unhealthy_threshold = 10          
    healthy_threshold   = 2
  }
}

resource "aws_lb_target_group" "demo_tg_8080" {
  name        = "demo-tg-8080"
  port        = 8080
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.demo_vpc.id

  health_check {
    path                = "/"  
    port                = 8080       
    protocol            = "HTTP"     
    interval            = 60
    timeout             = 5          
    unhealthy_threshold = 10         
    healthy_threshold   = 2         
}
}

resource "aws_lb_listener" "demo_listener_80" {
  load_balancer_arn = aws_lb.demo_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.demo_tg_80.arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "demo_listener_8080" {
  load_balancer_arn = aws_lb.demo_alb.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.demo_tg_8080.arn
    type             = "forward"
  }
}