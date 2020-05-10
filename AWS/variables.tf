locals {
  userdata = file("user-data.cloudconfig")
}

data "aws_availability_zones" "available" {
  state = "available"
}
