locals {
  userdata    = file("user-data.cloudconfig")
}

data "aws_availability_zones" "available" {
  state       = "available"
}

variable "keypair" {
  type        = string
  description = "Name of your SSH keypair."
  default     = ""
}
