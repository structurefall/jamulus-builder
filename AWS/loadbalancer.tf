resource "aws_lb" "jamulus" {
    name                = "jamulus"
    load_balancer_type  = "network"
    subnets             = [
      aws_subnet.jamulus_subnet.id
    ]
}

resource "aws_lb_target_group" "jamulus" {
  name                  = "jamulus-target-group"
  target_type           = "instance"
  vpc_id                = aws_vpc.jamulus.id
  port                  = 22124
  protocol              = "TCP_UDP"

  health_check {
    port                = 22124
    protocol            = "TCP"
    healthy_threshold   = 5
    unhealthy_threshold = 5
    interval            = 10
  }

  tags                  = {
    Application         = "jamulus"
  }
}

resource "aws_lb_listener" "jamulus_listener" {
  load_balancer_arn     = aws_lb.jamulus.arn
  port                  = 22124
  protocol              = "TCP_UDP"

  default_action {
    type                = "forward"
    target_group_arn    = aws_lb_target_group.jamulus.arn
  }
}

resource "aws_lb_target_group" "jamulus_ssh" {
  name                  = "jamulus-target-group-ssh"
  target_type           = "instance"
  vpc_id                = aws_vpc.jamulus.id
  port                  = 22
  protocol              = "TCP"

  tags                  = {
    Application         = "jamulus"
  }
}

resource "aws_lb_listener" "jamulus_ssh" {
  load_balancer_arn     = aws_lb.jamulus.arn
  port                  = 22
  protocol              = "TCP"

  default_action {
    type                = "forward"
    target_group_arn    = aws_lb_target_group.jamulus_ssh.arn
  }
}
