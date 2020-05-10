resource "aws_launch_configuration" "jamulus" {
    name_prefix             = "jamulus-launch-config-"
    image_id                = "ami-0f56279347d2fa43e"
    instance_type           = "t3.micro"
    security_groups         = [
      aws_security_group.jamulus.id
    ]

    user_data               = local.userdata

    key_name                = var.keypair

    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "jamulus" {
  name                      = "jamulus-autoscaler"
  max_size                  = 1
  min_size                  = 1
  health_check_type         = "EC2"
  launch_configuration      = aws_launch_configuration.jamulus.name

  vpc_zone_identifier       = [
    aws_subnet.jamulus_subnet_public.id
  ]

  tags                      = [
    {
      key                   = "Name",
      value                 = "Jamulus-Autoscale-Host",
      propagate_at_launch   = true
    },
    {
      key                   = "Application",
      value                 = "jamulus",
      propagate_at_launch   = true
    }
  ]
}
