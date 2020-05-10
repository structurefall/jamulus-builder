output "public_ip" {
  value = aws_eip.load_balancer_eip.public_ip
}
