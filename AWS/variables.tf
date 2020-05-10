locals {
  userdata    = file("user-data.cloudconfig")
  sshblocks   = concat(formatlist("%s/32", var.sships), [aws_subnet.jamulus_subnet.cidr_block])
}

data "aws_availability_zones" "available" {
  state       = "available"
}

variable "keypair" {
  type        = string
  description = "Name of your SSH keypair."
  default     = null
}

variable "sships" {
  type        = list(string)
  default     = []
}
