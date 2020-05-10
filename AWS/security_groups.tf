resource "aws_security_group" "jamulus" {
  name          = "jamulus"
  description   = "Public UDP access for Jamulus."
  vpc_id        = aws_vpc.jamulus.id

  ingress {
    from_port   = "22124"
    to_port     = "22124"
    protocol    = "udp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags          = {
    Application = "jamulus"
  }
}

resource "aws_security_group" "ssh" {
  name          = "jamulus-ssh"
  description   = "SSH access to Jamulus through NLB."
  vpc_id        = aws_vpc.jamulus.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = local.sshblocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags          = {
    Application = "jamulus"
  }
}
