output "VPC_ID" {
  value       = aws_vpc.AWS_VPC.id
  description = "The VPC ID"
}
output "gateway-ID" {
  value       = aws_internet_gateway.AWS_internet_gateway.id
  description = "The internet gateway ID"
}
