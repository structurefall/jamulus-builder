resource "aws_vpc" "jamulus" {
  cidr_block         = "172.16.0.0/16"

  tags               = {
    Name             = "jamulus-vpc"
    Application      = "jamulus"
  }
}

resource "aws_subnet" "jamulus_subnet_private" {
    vpc_id           = aws_vpc.jamulus.id
    cidr_block       = "172.16.0.0/24"

    tags             = {
      Name           = "jamulus-subnet-private"
      Application    = "jamulus"
    }
}

resource "aws_subnet" "jamulus_subnet_public" {
    vpc_id           = aws_vpc.jamulus.id
    cidr_block       = "172.16.1.0/24"

    tags             = {
      Name           = "jamulus-subnet-public"
      Application    = "jamulus"
    }
}

resource "aws_internet_gateway" "jamulus_internet" {
  vpc_id             = aws_vpc.jamulus.id

  tags               = {
    Name             = "jamulus-internet-gateway"
    Application      = "jamulus"
  }
}

resource "aws_route_table" "public" {
    vpc_id           = aws_vpc.jamulus.id

    route {
      cidr_block     = "0.0.0.0/0"
      gateway_id     = aws_internet_gateway.jamulus_internet.id
    }

    tags               = {
      Name             = "jamulus-public-route-table"
      Application      = "jamulus"
    }
}

resource "aws_route_table" "private" {
    vpc_id           = aws_vpc.jamulus.id

    route {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.jamulus.id
    }

    tags               = {
      Name             = "jamulus-private-route-table"
      Application      = "jamulus"
    }
}

resource "aws_route_table_association" "public" {
    subnet_id        = aws_subnet.jamulus_subnet_public.id
    route_table_id   = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
    subnet_id        = aws_subnet.jamulus_subnet_private.id
    route_table_id   = aws_route_table.private.id
}

resource "aws_eip" "nat_eip" {
  vpc                = true

  tags               = {
    Name             = "jamulus-nat-ip"
    Application      = "jamulus"
  }
}

resource "aws_nat_gateway" "jamulus" {
  allocation_id      = aws_eip.nat_eip.id
  subnet_id          = aws_subnet.jamulus_subnet_public.id

  tags               = {
    Name             = "jamulus-nat"
    Application      = "jamulus"
  }
}
