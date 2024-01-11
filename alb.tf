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
    path                = "/"  # Specify the path for health checks
    port                = 80         # Specify the port for health checks
    protocol            = "HTTP"     # Specify the protocol for health checks (HTTP or HTTPS)
    interval            = 30         # Specify the interval between health checks in seconds
    timeout             = 5          # Specify the amount of time, in seconds, during which no response means a failed health check
    unhealthy_threshold = 10          # Specify the number of consecutive health check failures required before considering a target unhealthy
    healthy_threshold   = 2        # Specify the number of consecutive health check successes required before considering a target healthy
  }
}

resource "aws_lb_target_group" "demo_tg_8080" {
  name        = "demo-tg-8080"
  port        = 8080
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.demo_vpc.id

  health_check {
    path                = "/"  # Specify the path for health checks
    port                = 8080       # Specify the port for health checks
    protocol            = "HTTP"     # Specify the protocol for health checks (HTTP or HTTPS)
    interval            = 30         # Specify the interval between health checks in seconds
    timeout             = 5          # Specify the amount of time, in seconds, during which no response means a failed health check
    unhealthy_threshold = 10          # Specify the number of consecutive health check failures required before considering a target unhealthy
    healthy_threshold   = 2          # Specify the number of consecutive health check successes required before considering a target healthy
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