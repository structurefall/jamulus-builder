resource "aws_lb" "jamulus" {
    name               = "jamulus-udp"
    load_balancer_type = "network"
    subnets            = [
      aws_subnet.jamulus_subnet_public.id
    ]
}

resource "aws_lb_target_group" "jamulus" {
  name                 = "jamulus-target-group"
  target_type          = "instance"
  vpc_id               = aws_vpc.jamulus.id
  port                 = 22124
  protocol             = "UDP"

  tags                 = {
    Application        = "jamulus"
  }
}

resource "aws_lb_listener" "jamulus_listener" {
  load_balancer_arn    = aws_lb.jamulus.arn
  port                 = 22124
  protocol             = "UDP"

  default_action {
    type               = "forward"
    target_group_arn   = aws_lb_target_group.jamulus.arn
  }
}
