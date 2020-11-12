#-------- Subnets---------
data "aws_availability_zones" "available" {}
resource "aws_subnet" "AWS-subnet" {
  vpc_id                  = var.VPC-ID
  cidr_block              = var.subnet-cidr
  map_public_ip_on_launch = var.map_public_ip
  availability_zone       = data.aws_availability_zones.available.names[var.AZ-index]
  tags = {
    Name = var.name
  }
}
#--------Subnet Associations------
resource "aws_route_table_association" "AWS-subnet-assoc" {
  subnet_id      = aws_subnet.AWS-subnet.id
  route_table_id = var.RT-ID
}
