resource "aws_vpc" "jamulus" {
  cidr_block               = "172.16.0.0/16"

  tags                     = {
    Name                   = "jamulus-vpc"
    Application            = "jamulus"
  }
}

resource "aws_subnet" "jamulus_subnet" {
    vpc_id                 = aws_vpc.jamulus.id
    cidr_block             = "172.16.0.0/24"

    tags                   = {
      Name                 = "jamulus-subnet"
      Application          = "jamulus"
    }
}

resource "aws_internet_gateway" "jamulus_internet" {
    vpc_id                 = aws_vpc.jamulus.id

    tags                   = {
      Name                 = "jamulus-internet-gateway"
      Application          = "jamulus"
    }
}

resource "aws_route" "route_to_internet" {
    route_table_id         = aws_vpc.jamulus.default_route_table_id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.jamulus_internet.id
}
