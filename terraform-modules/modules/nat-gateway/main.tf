#-------Elastic IP---------
resource "aws_eip" "EIP" {
  vpc        = true
  depends_on = [var.depends-on]
  tags = {
    Name = var.EIP-name
  }
}
#-------NAT Gateway-------
resource "aws_nat_gateway" "NAT_Gateway" {
  allocation_id = aws_eip.EIP.id
  subnet_id     = var.PUB-subnet-id
  tags = {
    Name = var.NAT-name
  }
}