#--------Route Tables-------
resource "aws_route_table" "AWS_RT" {
  vpc_id = var.VPC-ID
  route {
    cidr_block     = var.RT_cidr_block
    gateway_id     = var.Gateway-ID
    nat_gateway_id = var.NAT-ID
  }
  tags = {
    Name = var.name
  }
}