resource "aws_lb" "k8s_api_lb" {
  name = "k8s-api-lb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.master_node_sg.id]
  enable_deletion_protection = false

  enable_cross_zone_load_balancing = true
  idle_timeout = 60
  enable_http2 = true

  subnets = [aws_subnet.public_1.id]

  tags = {
    Name = "k8s-api-lb"
  }
}


resource "aws_lb_target_group" "k8s_api_tg" {
  name = "k8s-api-tg"
  port = 6443
  protocol = "TCP"
  vpc_id = aws_vpc.database_vpc.id

  health_check {
    enabled             = true
    interval            = 30
    port                = "6443"
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
    protocol            = "TCP"
  }
  tags = {
    "Name" = "k8s-api-tg"
  }
}

resource "aws_lb_listener" "k8s_api_listener" {
  load_balancer_arn = aws_lb.k8s_api_lb.arn
  port = "6443"
  protocol = "TCP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.k8s_api_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "k8s_api_tg_attachment" {
  target_group_arn = aws_lb_target_group.k8s_api_tg.arn
  target_id = aws_instance.master_node.id
  port = 6443
}