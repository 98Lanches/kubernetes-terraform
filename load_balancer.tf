resource "aws_lb" "dotlanche_api_lb" {
  name               = "dotlanche-api-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.basic_sg.id]
  subnets            = [
    aws_subnet.public_subnet_a.id,
    aws_subnet.public_subnet_b.id
  ]

  tags = {
    Name = "dotlanche-api-lb"
  }
}

resource "aws_lb_target_group" "dotlanche_api_tg" {
  name     = "dotlanche-api-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "dotlanche-api-tg"
  }
}

resource "aws_lb_listener" "dotlanche_api_listener" {
  load_balancer_arn = aws_lb.dotlanche_api_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dotlanche_api_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "dotlanche_api_tg_attachment" {
  target_group_arn = aws_lb_target_group.dotlanche_api_tg.arn
  target_id        = "PLACEHOLDER_FOR_KUBERNETES_SERVICE_IP"
  port             = 8080
}
