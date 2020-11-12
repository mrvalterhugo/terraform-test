
#------VPC-------
resource "aws_vpc" "AWS_VPC" {
  cidr_block           = var.VPC_CIDR
  enable_dns_hostnames = var.VPC_DNS_hostnames
  enable_dns_support   = var.VPC_DNS_support
  tags = {
    Name = var.VPC_name
  }
}
#-----Internet Gateway---------
resource "aws_internet_gateway" "AWS_internet_gateway" {
  vpc_id = aws_vpc.AWS_VPC.id
  tags = {
    Name = var.IG_name
  }
}