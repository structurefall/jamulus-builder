resource "aws_vpc" "jamulus" {
  cidr_block               = "172.16.0.0/16"

  tags                     = {
    Name                   = "jamulus-vpc"
    Application            = "jamulus"
  }
}

resource "aws_subnet" "jamulus_subnet_private" {
    vpc_id                 = aws_vpc.jamulus.id
    cidr_block             = "172.16.0.0/24"

    tags                   = {
      Name                 = "jamulus-subnet-private"
      Application          = "jamulus"
    }
}

resource "aws_subnet" "jamulus_subnet_public" {
    vpc_id                 = aws_vpc.jamulus.id
    cidr_block             = "172.16.1.0/24"

    tags                   = {
      Name                 = "jamulus-subnet-public"
      Application          = "jamulus"
    }
}

resource "aws_internet_gateway" "jamulus_internet" {
  vpc_id                   = aws_vpc.jamulus.id

  tags                     = {
    Name                   = "jamulus-internet-gateway"
    Application            = "jamulus"
  }
}

resource "aws_route" "route_to_internet" {
    route_table_id         = aws_vpc.jamulus.default_route_table_id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.jamulus_internet.id
}

resource "aws_eip" "load_balancer_eip" {
  vpc                      = true

  tags                     = {
    Name                   = "jamulus-elb-ip"
    Application            = "jamulus"
  }
}
